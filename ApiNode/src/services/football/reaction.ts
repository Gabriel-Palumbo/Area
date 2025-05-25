import { Request, Response } from 'express';
import axios from 'axios';
import { AuthenticatedRequest } from '../../auth/middelware';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDoc, where, query, getDocs, Timestamp, addDoc } from 'firebase/firestore';
import { matchesInfos } from './models/foot_models';
import { EventData } from '../event';
import { handleEvent } from '../sender';

const API_KEY = '2654b06a3a4b4bc4a4866e7a555b2a4a';

const LIGUE_IDS = {
    LIGUE_1: 2015,
    LIGUE_2: 2014,
    LIGUE_3: 2021,
    LIGUE_4: 2019,
    LIGUE_5: 2002
};

async function getLastMatchByLeague(leagueId: number): Promise<matchesInfos | null> {
    const url = `https://api.football-data.org/v4/competitions/${leagueId}/matches?status=FINISHED`;

    try {
        const response = await axios.get(url, {
            headers: {
                'X-Auth-Token': API_KEY
            }
        });

        if (response.status !== 200) {
            throw new Error(`Erreur lors de la récupération des matchs: ${response.statusText}`);
        }

        const matches = response.data.matches;
        const lastMatch = matches.sort((a: any, b: any) => new Date(b.utcDate).getTime() - new Date(a.utcDate).getTime())[0];

        if (!lastMatch) return null;

        return parseMatchData(lastMatch);
    } catch (error) {
        console.error('Erreur lors de la récupération des informations:', error);
        return null;
    }
}

function parseMatchData(match: any): matchesInfos {
    const homeTeam = match.homeTeam;
    const awayTeam = match.awayTeam;
    const venue = match.venue;

    return {
        date: Timestamp.fromDate(new Date(match.utcDate)),
        team1: homeTeam.name,
        team2: awayTeam.name,
        symbol_team1: homeTeam.crest,
        symbol_team2: awayTeam.crest,
        stade: venue?.name || 'Stade inconnu',
        last_updated: Timestamp.now()
    };
}

// Fonctions pour chaque ligue
async function fetchLigue1Match() {
    return await getLastMatchByLeague(LIGUE_IDS.LIGUE_1);
}

async function fetchLigue2Match() {
    return await getLastMatchByLeague(LIGUE_IDS.LIGUE_2);
}

async function fetchSerieAMatch() {
    return await getLastMatchByLeague(LIGUE_IDS.LIGUE_3);
}

async function fetchPremierLeagueMatch() {
    return await getLastMatchByLeague(LIGUE_IDS.LIGUE_4);
}

async function fetchLigueBBVAMatch() {
    return await getLastMatchByLeague(LIGUE_IDS.LIGUE_5);
}

function formatMatchMessage(matchData: matchesInfos): string {
    const { date, team1, team2, symbol_team1, symbol_team2, stade, team1_composition, team2_composition, last_updated } = matchData;

    const matchDate = new Date(date.toDate()).toLocaleString('fr-FR', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
    });
    
    let message = `⚽ **Dernier match : ${team1} vs ${team2}** ⚽\n\n`;
    message += `📅 **Date :** ${matchDate}\n`;
    message += `📍 **Stade :** ${stade}\n\n`;
    
    message += `**${team1}** ${symbol_team1 ? `![Logo](${symbol_team1})` : ''} vs ${symbol_team2 ? `![Logo](${symbol_team2})` : ''} **${team2}**\n\n`;

    message += `**Composition de ${team1} :**\n`;
    message += team1_composition?.length ? team1_composition?.join(', ') : 'Données indisponibles';
    message += `\n\n**Composition de ${team2} :**\n`;
    message += team2_composition?.length ? team2_composition?.join(', ') : 'Données indisponibles';

    message += `\n\n🕒 **Dernière mise à jour :** ${new Date(last_updated.toDate()).toLocaleString('fr-FR')}\n`;

    return message;
}


export async function handleFootballReaction(reaction: string, event: EventData) {
    try {
        let matchData;
        
        switch (reaction) {
            case 'football/get_ligue1':
                matchData = await fetchLigue1Match();
                break;
            case 'football/get_ligue2':
                matchData = await fetchLigue2Match();
                break;
            case 'football/get_ligue3':
                matchData = await fetchSerieAMatch();
                break;
            case 'football/get_ligue4':
                matchData = await fetchPremierLeagueMatch();
                break;
            case 'football/get_ligue5':
                matchData = await fetchLigueBBVAMatch();
                break;
            default:
                return;
        }

        if (!matchData) {
            console.error(`Aucun match trouvé pour la réaction ${reaction}`);
            return;
        }

        const docRef = doc(db, 'users', event.userId, 'services', 'football');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            console.error(`No football service found for user ${event.userId}`);
            return;
        }

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';
        
        const message = formatMatchMessage(matchData);
        
        console.log(`Message formatté pour ${reaction}:`, message);
        handleEvent(event.userId, message, sender);
    } catch (error) {
        console.error(`Error handling football reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}
