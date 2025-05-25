
import { Request, Response } from 'express';
import axios from 'axios';
import { AuthenticatedRequest } from '../../auth/middelware';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDoc, where, query, getDocs, Timestamp, addDoc } from 'firebase/firestore';
import { matchesInfos } from './models/foot_models';


const API_KEY = '2654b06a3a4b4bc4a4866e7a555b2a4a';
const LIGUE_1_ID = 2015;
const LIGUE_2_ID = 2014;
const LIGUE_3_ID = 2021;
const LIGUE_4_ID = 2019;
const LIGUE_5_ID = 2002;

export async function RrefreshLeaugue1(req: Request, res: Response): Promise<Response> {
  const today = new Date().toISOString().split('T')[0];
  const url = `https://api.football-data.org/v4/competitions/${LIGUE_1_ID}/matches?dateFrom=${today}&dateTo=${today}`;

  try {
      const response = await fetch(url, {
          headers: {
              'X-Auth-Token': API_KEY
          }
      });

      if (!response.ok) {
          throw new Error(`Erreur lors de la récupération des matchs: ${response.statusText}`);
      }

      const data = await response.json();

      //Création de la structure 'commun -> services -> foot -> data -> {today}'
      const footRef = doc(db, 'commun', 'services', 'foot', 'data');
      const dataRef = doc(collection(footRef, 'matches'), today);

      await setDoc(dataRef, data);

      return res.status(200).json({
          message: 'Infos de Ligue 1 sauvegardées avec succès.',
          data: data.matches
      });
  } catch (error) {
      console.error('Erreur:', error);
      return res.status(500).json({
          message: 'Erreur lors de la sauvegarde des informations de Ligue 1.',
      });
  }
}

export async function getTodayMatches(req: Request, res: Response): Promise<Response> {
  const today = new Date().toISOString().split('T')[0];
  const url = `https://api.football-data.org/v4/competitions/${LIGUE_1_ID}/matches?dateFrom=${today}&dateTo=${today}`;
  console.log("Appel API pour les matchs de Ligue 1");

  try {
      const response = await axios.get(url, {
          headers: {
              'X-Auth-Token': API_KEY
          }
      });

      if (response.status !== 200) {
          throw new Error(`Erreur lors de la récupération des matchs: ${response.statusText}`);
      }

      const data = response.data.matches;

      const matches: matchesInfos[] = data.map((match: { utcDate: string | number | Date; homeTeam: { name: any; crestUrl: any; }; awayTeam: { name: any; crestUrl: any; }; venue: any; lineups: { players: any[]; }[]; }) => ({
          date: Timestamp.fromDate(new Date(match.utcDate)),
          team1: match.homeTeam.name,
          team2: match.awayTeam.name,
          last_updated: Timestamp.now()
      }));


      return res.status(200).json({
          message: 'Infos de Ligue 1 sauvegardées avec succès.',
          data: matches
      });
  } catch (error) {
      console.error('Erreur:', error);
      return res.status(500).json({
          message: 'Erreur lors de la sauvegarde des informations de Ligue 1.',
      });
  }
}

export async function getLastMatch_L1(req: Request, res: Response): Promise<Response> {
  const url = `https://api.football-data.org/v4/competitions/${LIGUE_1_ID}/matches?status=FINISHED`;

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

      if (!lastMatch) {
          return res.status(404).json({
              message: 'Aucun match trouvé.'
          });
      }

      const homeTeam = lastMatch.homeTeam;
      const awayTeam = lastMatch.awayTeam;
      const venue = lastMatch.venue;

      if (!homeTeam || !awayTeam || !venue) {
          console.error('Détails manquants:', lastMatch);
          return res.status(404).json({
              message: 'Les données de l\'équipe ou du stade sont manquantes.',
              lastMatch
          });
      }

      const matchInfo: matchesInfos = {
          date: Timestamp.fromDate(new Date(lastMatch.utcDate)),
          team1: homeTeam.name,
          team2: awayTeam.name,
          symbol_team1: homeTeam.crest,
          symbol_team2: awayTeam.crest,
          stade: venue.name,
          team1_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === homeTeam.id)?.players.map((player: any) => player.name) || [],
          team2_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === awayTeam.id)?.players.map((player: any) => player.name) || [],
          last_updated: Timestamp.now()
      };

      return res.status(200).json({
          message: 'Dernier match récupéré avec succès.',
          data: matchInfo
      });
  } catch (error) {
      console.error('Erreur:', error);
      return res.status(500).json({
          message: 'Erreur lors de la récupération des informations de Ligue 1.',
      });
  }
}

export async function getLastMatch_L2(req: Request, res: Response): Promise<Response> {
  const url = `https://api.football-data.org/v4/competitions/${LIGUE_2_ID}/matches?status=FINISHED`;

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

      if (!lastMatch) {
          return res.status(404).json({
              message: 'Aucun match trouvé.'
          });
      }

      const homeTeam = lastMatch.homeTeam;
      const awayTeam = lastMatch.awayTeam;
      const venue = lastMatch.venue;

      if (!homeTeam || !awayTeam || !venue) {
          console.error('Détails manquants:', lastMatch); // Débogage
          return res.status(404).json({
              message: 'Les données de l\'équipe ou du stade sont manquantes.',
              lastMatch
          });
      }

      const matchInfo: matchesInfos = {
          date: Timestamp.fromDate(new Date(lastMatch.utcDate)),
          team1: homeTeam.name,
          team2: awayTeam.name,
          symbol_team1: homeTeam.crest,
          symbol_team2: awayTeam.crest,
          stade: venue.name,
          team1_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === homeTeam.id)?.players.map((player: any) => player.name) || [],
          team2_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === awayTeam.id)?.players.map((player: any) => player.name) || [],
          last_updated: Timestamp.now()
      };

      return res.status(200).json({
          message: 'Dernier match récupéré avec succès.',
          data: matchInfo
      });
  } catch (error) {
      console.error('Erreur:', error);
      return res.status(500).json({
          message: 'Erreur lors de la récupération des informations de Ligue 1.',
      });
  }
}

export async function getLastMatch_L3(req: Request, res: Response): Promise<Response> {
  const url = `https://api.football-data.org/v4/competitions/${LIGUE_3_ID}/matches?status=FINISHED`;

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

      if (!lastMatch) {
          return res.status(404).json({
              message: 'Aucun match trouvé.'
          });
      }

      const homeTeam = lastMatch.homeTeam;
      const awayTeam = lastMatch.awayTeam;
      const venue = lastMatch.venue;

      if (!homeTeam || !awayTeam || !venue) {
          console.error('Détails manquants:', lastMatch);
          return res.status(404).json({
              message: 'Les données de l\'équipe ou du stade sont manquantes.',
              lastMatch
          });
      }

      const matchInfo: matchesInfos = {
          date: Timestamp.fromDate(new Date(lastMatch.utcDate)),
          team1: homeTeam.name,
          team2: awayTeam.name,
          symbol_team1: homeTeam.crest,
          symbol_team2: awayTeam.crest,
          stade: venue.name,
          team1_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === homeTeam.id)?.players.map((player: any) => player.name) || [],
          team2_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === awayTeam.id)?.players.map((player: any) => player.name) || [],
          last_updated: Timestamp.now()
      };

      return res.status(200).json({
          message: 'Dernier match récupéré avec succès.',
          data: matchInfo
      });
  } catch (error) {
      console.error('Erreur:', error);
      return res.status(500).json({
          message: 'Erreur lors de la récupération des informations de Ligue 1.',
      });
  }
}
 
export async function getLastMatch_L4(req: Request, res: Response): Promise<Response> {
    const url = `https://api.football-data.org/v4/competitions/${LIGUE_4_ID}/matches?status=FINISHED`;

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
  
        if (!lastMatch) {
            return res.status(404).json({
                message: 'Aucun match trouvé.'
            });
        }
  
        const homeTeam = lastMatch.homeTeam;
        const awayTeam = lastMatch.awayTeam;
        const venue = lastMatch.venue;
  
        if (!homeTeam || !awayTeam || !venue) {
            console.error('Détails manquants:', lastMatch); 
            return res.status(404).json({
                message: 'Les données de l\'équipe ou du stade sont manquantes.',
                lastMatch
            });
        }
  
        const matchInfo: matchesInfos = {
            date: Timestamp.fromDate(new Date(lastMatch.utcDate)),
            team1: homeTeam.name,
            team2: awayTeam.name,
            symbol_team1: homeTeam.crest,
            symbol_team2: awayTeam.crest,
            stade: venue.name, 
            team1_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === homeTeam.id)?.players.map((player: any) => player.name) || [],
            team2_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === awayTeam.id)?.players.map((player: any) => player.name) || [],
            last_updated: Timestamp.now()
        };
  
        return res.status(200).json({
            message: 'Dernier match récupéré avec succès.',
            data: matchInfo
        });
    } catch (error) {
        console.error('Erreur:', error);
        return res.status(500).json({
            message: 'Erreur lors de la récupération des informations de Ligue 1.',
        });
    }
}
  
export async function getLastMatch_L5(req: Request, res: Response): Promise<Response> {
    const url = `https://api.football-data.org/v4/competitions/${LIGUE_5_ID}/matches?status=FINISHED`;

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
  
        if (!lastMatch) {
            return res.status(404).json({
                message: 'Aucun match trouvé.'
            });
        }
  
        const homeTeam = lastMatch.homeTeam;
        const awayTeam = lastMatch.awayTeam;
        const venue = lastMatch.venue;
  
        if (!homeTeam || !awayTeam || !venue) {
            console.error('Détails manquants:', lastMatch);
            return res.status(404).json({
                message: 'Les données de l\'équipe ou du stade sont manquantes.',
                lastMatch
            });
        }
  
        const matchInfo: matchesInfos = {
            date: Timestamp.fromDate(new Date(lastMatch.utcDate)),
            team1: homeTeam.name,
            team2: awayTeam.name,
            symbol_team1: homeTeam.crest,
            symbol_team2: awayTeam.crest,
            stade: venue.name,
            team1_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === homeTeam.id)?.players.map((player: any) => player.name) || [],
            team2_composition: lastMatch.lineups.find((lineup: any) => lineup.team.id === awayTeam.id)?.players.map((player: any) => player.name) || [],
            last_updated: Timestamp.now()
        };
  
        return res.status(200).json({
            message: 'Dernier match récupéré avec succès.',
            data: matchInfo
        });
    } catch (error) {
        console.error('Erreur:', error);
        return res.status(500).json({
            message: 'Erreur lors de la récupération des informations de Ligue 1.',
        });
    }
}
