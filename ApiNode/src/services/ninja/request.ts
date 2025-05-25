import { doc, getDoc } from "firebase/firestore";
import { handleEvent } from "../sender";
import { db } from "../../init_db";
import { EventData } from "../event";
import axios from "axios";

export async function handleNinjaQuotesReaction(reaction: string, event: EventData) {
    try {
        let quotesData;

        switch (reaction) {
            case 'quotes/get_inspirational_quote':
                quotesData = await fetchNinjaQuotes('inspirational');
                break;
            case 'quotes/get_health_quote':
                quotesData = await fetchNinjaQuotes('health');
                break;
            case 'quotes/get_humor_quote':
                quotesData = await fetchNinjaQuotes('humor');
                break;
            case 'quotes/get_business_quote':
                quotesData = await fetchNinjaQuotes('business');
                break;
            default:
                return;
        }

        const docRef = doc(db, 'users', event.userId, 'services', 'quotes');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            console.error(`No quotes service found for user ${event.userId}`);
            return;
        }

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';

        const quoteMessage = quotesData[0]
            ? `${quotesData[0].quote} - ${quotesData[0].author}`
            : "No quote found.";

        handleEvent(event.userId, quoteMessage, sender);
    } catch (error) {
        console.error(`Error handling Ninja Quotes reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}

async function fetchNinjaQuotes(category: string) {
    const response = await axios.get(`https://api.api-ninjas.com/v1/quotes?category=${category}`, {
        headers: { 'X-Api-Key': process.env.NINJA_APIKEY }
    });

    if (response.status !== 200) {
        throw new Error(`Failed to fetch quotes: ${response.statusText}`);
    }

    return response.data.map((item: any) => ({
        quote: item.quote,
        author: item.author,
        category: item.category,
    }));
}
