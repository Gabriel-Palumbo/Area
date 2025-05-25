import { doc, getDoc } from "firebase/firestore";
import { EventData } from "../event";
import { handleEvent } from "../sender";
import { CoinInfos } from "./models/coin_models";
import { db } from "../../init_db";

export async function getBitCoinInfos(): Promise<CoinInfos | null> {
    try {
        const response = await fetch('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest', {
            method: 'GET',
            headers: {
                'Accept': '*/*',
                'X-CMC_PRO_API_KEY': 'a9f21d32-992b-4fb5-83c0-d2c958789d12'
            },
        });
        const data = await response.json();
        const cryptoArray = data.data;

        let bitcoinInfos = cryptoArray.find((item: any) => item.name === "Bitcoin");

        const event_details : CoinInfos = {
            name: bitcoinInfos.name,
            symbol: bitcoinInfos.symbol,
            price: bitcoinInfos.quote.USD.price,
            last_updated: bitcoinInfos.quote.USD.last_updated,
        }

        return event_details;
    } catch (error) {
        return null;
    }
}


export async function getEthereumInfos(): Promise<CoinInfos | null> {
    try {
        const response = await fetch('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest', {
            method: 'GET',
            headers: {
                'Accept': '*/*',
                'X-CMC_PRO_API_KEY': 'a9f21d32-992b-4fb5-83c0-d2c958789d12'
            },
        });
        const data = await response.json();
        const cryptoArray = data.data;

        let bitcoinInfos = cryptoArray.find((item: any) => item.name === "Ethereum");

        const event_details : CoinInfos = {
            name: bitcoinInfos.name,
            symbol: bitcoinInfos.symbol,
            price: bitcoinInfos.quote.USD.price,
            last_updated: bitcoinInfos.quote.USD.last_updated,
        }

        return event_details;
    } catch (error) {
        return null;
    }
}


export async function getSolanaInfos(): Promise<CoinInfos | null> {
    try {
        const response = await fetch('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest', {
            method: 'GET',
            headers: {
                'Accept': '*/*',
                'X-CMC_PRO_API_KEY': 'a9f21d32-992b-4fb5-83c0-d2c958789d12'
            },
        });
        const data = await response.json();
        const cryptoArray = data.data;

        let bitcoinInfos = cryptoArray.find((item: any) => item.name === "Solana");

        const event_details : CoinInfos = {
            name: bitcoinInfos.name,
            symbol: bitcoinInfos.symbol,
            price: bitcoinInfos.quote.USD.price,
            last_updated: bitcoinInfos.quote.USD.last_updated,
        }

        return event_details;
    } catch (error) {
        return null;
    }
}


export async function getTetherInfos(): Promise<CoinInfos | null> {
    try {
        const response = await fetch('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest', {
            method: 'GET',
            headers: {
                'Accept': '*/*',
                'X-CMC_PRO_API_KEY': 'a9f21d32-992b-4fb5-83c0-d2c958789d12'
            },
        });
        const data = await response.json();
        const cryptoArray = data.data;

        let bitcoinInfos = cryptoArray.find((item: any) => item.name === "Tether USDt");

        const event_details : CoinInfos = {
            name: bitcoinInfos.name,
            symbol: bitcoinInfos.symbol,
            price: bitcoinInfos.quote.USD.price,
            last_updated: bitcoinInfos.quote.USD.last_updated,
        }

        return event_details;
    } catch (error) {
        return null;
    }
}

export async function handleCryptoReaction(reaction: string, event: EventData) {
    try {
        let cryptoData: CoinInfos | null;

        switch (reaction) {
            case 'coincap/get_bitcoin_price':
                cryptoData = await getBitCoinInfos();
                break;
            case 'coincap/get_ethereum_price':
                cryptoData = await getEthereumInfos();
                break;
            case 'coincap/get_solana_price':
                cryptoData = await getSolanaInfos();
                break;
            case 'coincap/get_tether_price':
                cryptoData = await getTetherInfos();
                break;
            default:
                console.warn(`Unknown cryptocurrency reaction type: ${reaction}`);
                return;
        }

        if (cryptoData) {
            const message = `${cryptoData.name}-${cryptoData.symbol}, price : ${cryptoData.price}`;

            const docRef = doc(db, 'users', event.userId, 'services', 'coincap');
            const docSnapshot = await getDoc(docRef);

            if (!docSnapshot.exists()) {
                console.error(`No coincap service found for user ${event.userId}`);
                return;
            }

            const data = docSnapshot.data();
            const sender = data?.sender as 'telegram' | 'discord' | 'slack';
            
            console.log(`Fetched cryptocurrency data for ${reaction}:`, cryptoData);
            handleEvent(event.userId, message, sender);
        } else {
            console.warn(`No data available for reaction ${reaction}`);
        }
    } catch (error) {
        console.error(`Error handling cryptocurrency reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}
