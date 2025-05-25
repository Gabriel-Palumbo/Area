import { StockInfos } from "./models/marketinfo";
import { doc, getDoc } from "firebase/firestore";
import { Timestamp } from "firebase/firestore";
import { handleEvent } from "../sender";
import { EventData } from "../event";
import { db } from "../../init_db";

const FINNHUB_API_KEY = process.env.FINNHUB_API_KEY;

export async function handleStockReaction(reaction: string, event: EventData) {
    try {
        let stockData: StockInfos | null;

        switch (reaction) {
            case 'stocks/get_apple_info':
                stockData = await fetchStockPrice('AAPL');
                break;
            case 'stocks/get_google_info':
                stockData = await fetchStockPrice('GOOGL');
                break;
            case 'stocks/get_tesla_info':
                stockData = await fetchStockPrice('TSLA');
                break;
            case 'stocks/get_gm_info':
                stockData = await fetchStockPrice('GM');
                break;
            case 'stocks/get_microsoft_info':
                stockData = await fetchStockPrice('MSFT');
                break;
            case 'stocks/get_facebook_info':
                stockData = await fetchStockPrice('META');
                break;
            default:
                return;
        }

        if (!stockData) {
            console.warn(`No stock data found for reaction: ${reaction}`);
            return;
        }

        const docRef = doc(db, 'users', event.userId, 'services', 'stocks');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            console.error(`No stocks service found for user ${event.userId}`);
            return;
        }

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';

        const message = `Stock Info for ${stockData.name} (${stockData.symbol}):\n` +
                        `Price: $${stockData.price}\n` +
                        `Last Updated: ${stockData.last_updated.toDate().toLocaleString()}`;

        handleEvent(event.userId, message, sender);
    } catch (error) {
        console.error(`Error handling stock reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}

async function fetchStockPrice(symbol: string): Promise<StockInfos | null> {
    try {
        const response = await fetch(`https://finnhub.io/api/v1/quote?symbol=${symbol}&token=${FINNHUB_API_KEY}`, {
            method: 'GET',
            headers: { 'Accept': 'application/json' },
        });
        const data = await response.json();

        if (!data.c || data.c === 0) {
            console.warn(`No price data for symbol: ${symbol}`);
            return null;
        }

        const stockInfo: StockInfos = {
            name: symbol,
            symbol: symbol,
            price: data.c,
            last_updated: Timestamp.now()
        };

        return stockInfo;
    } catch (error) {
        console.error(`Error fetching stock data for ${symbol}:`, error);
        return null;
    }
}
