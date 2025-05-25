import { doc, getDoc } from "firebase/firestore";
import { EventData } from "../event";
import { db } from "../../init_db";
import { handleEvent } from "../sender";

const axios = require('axios');

const API_KEY = process.env.MEDIA_TOKEN;
const BASE_URL = 'http://api.mediastack.com/v1/news';


export async function fetchNews(keyword: string) {
    try {
        const response = await axios.get(`${BASE_URL}`, {
            params: {
                access_key: API_KEY,
                keywords: keyword,
                sort: 'published_desc',
                limit: 1,
            },
        });
        const message = `${response.data.data[0].title} - ${response.data.data[0].description} (Autheur: ${response.data.data[0].author})`;
        return message;
    } catch (error) {
        console.error(`Error fetching news for ${keyword}:`, error);
        throw error;
    }
}

async function fetchEnvironmentNews() : Promise<string> {
    return await fetchNews('environment');
}

async function fetchHealthNews() : Promise<string> {
    return await fetchNews('health');
}

async function fetchTechnologyNews() : Promise<string> {
    return await fetchNews('technology');
}

async function fetchSportsNews() : Promise<string> {
    return await fetchNews('sports');
}

async function fetchFinanceNews() : Promise<string> {
    return await fetchNews('finance');
}

export async function handleNewsReaction(reaction: string, event: EventData) {
    try {
        let newsData;
        
        switch (reaction) {
            case 'news/get_environment_news':
                newsData = await fetchEnvironmentNews();
                break;
            case 'news/get_health_news':
                newsData = await fetchHealthNews();
                break;
            case 'news/get_technology_news':
                newsData = await fetchTechnologyNews();
                break;
            case 'news/get_sports_news':
                newsData = await fetchSportsNews();
                break;
            case 'news/get_finance_news':
                newsData = await fetchFinanceNews();
                break;
            default:
                console.warn(`Unknown Mediastack reaction type: ${reaction}`);
                return;
        }
        
        const docRef = doc(db, 'users', event.userId, 'services', 'news');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            console.error(`No news service found for user ${event.userId}`);
            return;
        }

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';

        handleEvent(event.userId, newsData, sender);
    } catch (error) {
        console.error(`Error handling Mediastack reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}