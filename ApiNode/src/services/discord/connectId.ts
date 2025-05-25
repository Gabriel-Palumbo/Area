import { Request, Response } from 'express';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDoc, where, query, getDocs } from 'firebase/firestore';
import { AuthenticatedRequest } from '../../auth/middelware';

export async function storeDiscordDiscordId(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const { discordId, channelId } = req.body;
    const userId = req.user?.userId;

    if (!userId || !channelId) {
        return res.status(400).json({ message: 'userId ou channelId manquant.' });
    }

    try {
        const userRef = doc(db, 'users', userId);
        const discordServiceRef = doc(collection(userRef, 'services'), 'discord');

        await setDoc(discordServiceRef, { discordId, channelId });

        return res.status(200).json({
            message: 'Id Discord sauvegardé avec succès.',
        });
    } catch (error) {
        console.error('Erreur lors du stockage du webhook Discord :', error);
        return res.status(500).json({ message: 'Erreur serveur lors de la sauvegarde du webhook.' });
    }
}
