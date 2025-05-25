import { getDoc, doc, collection, getDocs, updateDoc, arrayUnion, arrayRemove, Timestamp, deleteField } from "firebase/firestore";
import { db } from '../init_db';
import { Request, Response } from 'express';
import { AuthenticatedRequest } from '../auth/middelware';

export async function createAreaRoute(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        const { service, action, reactions } = req.body;

        if (!userId || !service || !action || !reactions || !Array.isArray(reactions)) {
            return res.status(400).json({ message: "Invalid request parameters" });
        }

        const serviceDoc = doc(db, 'users', userId, "services", service);

        const createdAt = Timestamp.fromDate(new Date());


        await updateDoc(serviceDoc, {
            [`action_reactions.${action}`]: arrayUnion(...reactions, createdAt),
        });

        return res.status(200).json({ message: `Action reactions updated successfully for service: ${service}` });

    } catch (error) {
        console.error("Error adding action_reaction:", error);
        return res.status(500).json({ message: 'Failed to update action reactions' });
    }
};

export async function deleteAreaRoute(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        const { service, action } = req.body;

        if (!userId || !service || !action) {
            return res.status(400).json({ message: "Invalid request parameters" });
        }

        const serviceDoc = doc(db, 'users', userId, "services", service);

        
        await updateDoc(serviceDoc, {
            [`action_reactions.${action}`]: deleteField(),
        });

        return res.status(200).json({ message: `Action reactions removed successfully for service: ${service}` });

    } catch (error) {
        console.error("Error removing action_reaction:", error);
        return res.status(500).json({ message: 'Failed to remove action reactions' });
    }
}
