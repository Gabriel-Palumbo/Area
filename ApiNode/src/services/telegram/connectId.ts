import { Request, Response } from 'express';
import { db } from '../../init_db';
import { doc, setDoc, collection } from 'firebase/firestore';
import { AuthenticatedRequest } from '../../auth/middelware';

export async function storeTelegramId(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const { telegramId } = req.body;
    const userId = req.user?.userId;

    if (!userId || !telegramId) {
        return res.status(400).json({ message: 'userId ou telegramId manquant.' });
    }

    try {
        const userRef = doc(db, 'users', userId);
        const telegramServiceRef = doc(collection(userRef, 'services'), 'telegram');

        await setDoc(telegramServiceRef, { telegramId: telegramId, offset: 0, awaitingChannelMention: true });

        return res.status(200).json({
            message: 'Id Telegram sauvegardé avec succès.',
        });
    } catch (error) {
        console.error('Erreur lors du stockage de l\'ID Telegram :', error);
        return res.status(500).json({ message: 'Erreur serveur lors de la sauvegarde de l\'ID Telegram.' });
    }
}
