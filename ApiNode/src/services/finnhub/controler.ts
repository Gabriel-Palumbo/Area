import { Timestamp } from "firebase/firestore";
import { StockInfos } from "./models/marketinfo";

const FINNHUB_API_KEY = process.env.FINNHUB_API_KEY;

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

        // ! DATA OBJECT POUR GABRIEL
        const stockInfo: StockInfos = {
            name: symbol,
            symbol: symbol,
            price: data.c,
            last_updated:Timestamp.now()
        };

        return stockInfo;
    } catch (error) {
        console.error(`Error fetching stock data for ${symbol}:`, error);
        return null;
    }
}

export async function getAppleInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('AAPL');
}

export async function getGoogleInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('GOOGL');
}

export async function getTeslaInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('TSLA');
}

export async function getGMInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('GM');
}

export async function getMicrosoftInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('MSFT');} 

export async function getFacebookInfo(): Promise<StockInfos | null> {
    return fetchStockPrice('META');}