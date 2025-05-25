import { Response } from 'express';
import { AuthenticatedRequest } from '../../auth/middelware';
import { collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../init_db';

export async function saveAreaSender(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const area = req.body.area;
        const sender = req.body.sender;
        const userId = req.user?.userId;

        if (!userId) {
            return res.status(400).send('User ID is missing.');
        }

        if (!area) {
            return res.status(400).send('Area name is missing.');
        }

        if (!sender) {
            return res.status(400).send('No Sender!!!');
        }

        const docRef = doc(db, 'users', userId, 'services', 'time');

        await setDoc(docRef, { area, sender }, { merge: true });

        return res.status(200).send('Area and Token name saved successfully');
    } catch (error) {
        console.log(error);
        return res.status(500).send('Server Error: when trying to save the Token or Area');
    }
}
