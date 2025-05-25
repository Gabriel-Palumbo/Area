import { Response } from 'express';
import { AuthenticatedRequest } from '../../auth/middelware';
import { collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../init_db';

export async function saveTravelDetails(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const { origin, destination, apikey, sender } = req.body;
        const userId = req.user?.userId;

        if (!userId) {
            return res.status(400).send('User ID is missing snif.');
        }

        if (!origin || !destination || !apikey || !sender) {
            return res.status(400).send('Missing required travel details.');
        }

        const docRef = doc(db, 'users', userId, 'services', 'googlemap');

        const travelData = {
            origin,
            destination,
            apikey,
            sender,
        };

        await setDoc(docRef, travelData, { merge: true });

        return res.status(200).send('Travel details saved successfully');
    } catch (error) {
        console.error('Error saving travel details:', error);
        return res.status(500).send('Server error: could not save travel details');
    }
}
