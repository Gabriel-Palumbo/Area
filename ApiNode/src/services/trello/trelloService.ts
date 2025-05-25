import axios from 'axios';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDoc, onSnapshot, QueryDocumentSnapshot } from 'firebase/firestore';

const TRELLO_API_BASE = 'https://api.trello.com/1';

export async function getTrelloUserByToken(token: string, apiKey: string) {
    try {
        const response = await axios.get(`${TRELLO_API_BASE}/members/me`, {
            params: {
                key: apiKey,
                token: token
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching Trello user info:', error);
        return null;
    }
}

export async function saveTrelloUserToDB(userId: string, trelloData: any) {
    try {
        const userRef = doc(db, 'users', userId);
        const trelloServiceRef = doc(collection(userRef, 'services'), 'trello');
        await setDoc(trelloServiceRef, trelloData);
    } catch (error) {
        console.error('Error saving Trello user to DB:', error);
        throw error;
    }
}

export async function getUserBoards(token: string, apiKey: string) {
    try {
        const response = await axios.get(`${TRELLO_API_BASE}/members/me/boards`, {
            params: {
                key: apiKey,
                token: token,
                fields: 'name,url'
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching user boards:', error);
        return [];
    }
}

export async function listAllBoards(token: string, apiKey: string) {
    try {
        const boards = await getUserBoards(token, apiKey);
        return boards.map((board: any) => ({
            id: board.id,
            name: board.name,
            url: board.url
        }));
    } catch (error) {
        console.error('Error listing all boards:', error);
        return [];
    }
}

export async function setupCardStatusChangeListener(userId: string, token: string, apiKey: string, boardId: string, callback: (card: any) => void) {
    const userRef = doc(db, 'users', userId);
    const trelloServiceRef = doc(collection(userRef, 'services'), 'trello');

    // Set up Firestore listener
    const unsubscribe = onSnapshot(trelloServiceRef, async (doc: QueryDocumentSnapshot) => {
        if (doc.exists()) {
            const data = doc.data();
            const lastUpdatedCard = data.lastUpdatedCard;

            if (lastUpdatedCard) {
                callback(lastUpdatedCard);
            }
        }
    });

    const checkInterval = setInterval(async () => {
        try {
            const response = await axios.get(`${TRELLO_API_BASE}/boards/${boardId}/actions`, {
                params: {
                    key: apiKey,
                    token: token,
                    filter: 'updateCard:idList'
                }
            });

            const latestCardUpdate = response.data[0];

            if (latestCardUpdate) {
                await setDoc(trelloServiceRef, { lastUpdatedCard: latestCardUpdate }, { merge: true });
            }
        } catch (error) {
            console.error('Error checking for card status changes:', error);
        }
    }, 60000);

    return () => {
        unsubscribe();
        clearInterval(checkInterval);
    };
}
