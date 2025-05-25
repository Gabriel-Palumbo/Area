import { Request, Response } from 'express';
import { db } from '../../init_db';
import { doc, setDoc, getDoc, collection, Timestamp } from 'firebase/firestore';
import { AuthenticatedRequest } from '../../auth/middelware';
import { getGmailUserByToken, saveGoogleMailUserToDB, getEmailsFromGmail, createGmailWebhook, getUsersWithGmailLogin } from './googleMailService';  // Les services à implémenter pour interagir avec l'API Gmail

const REDIRECT_URI_GOOGLE = `${process.env.APP_URL}/google/callback`;

export async function storeGoogleMailToken(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const { googleMailToken } = req.body;
    const userId = req.user?.userId;

    try {
        const googleMailUserData = await getGmailUserByToken(googleMailToken);
        if (googleMailUserData) {
            await saveGoogleMailUserToDB(userId, { ...googleMailUserData, token: googleMailToken });

            const userRef = doc(db, 'users', userId);
            const googleMailServiceRef = doc(collection(userRef, 'services'), 'googleMail');
            await setDoc(googleMailServiceRef, { token: googleMailToken, userinfo: googleMailUserData });

            return res.status(200).json({
                message: 'Google Mail token et infos utilisateur sauvegardés avec succès.',
                userinfo: googleMailUserData
            });
        } else {
            return res.status(400).json({ message: 'Impossible de récupérer les infos Google Mail.' });
        }
    } catch (error) {
        console.error('Erreur lors du stockage des informations Google Mail :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}

/**
 * Récupérer les emails d'un utilisateur à partir de son token
 */
export async function getUserEmails(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const userId = req.user?.userId;

    try {
        const userRef = doc(db, 'users', userId);
        const googleMailServiceRef = doc(collection(userRef, 'services'), 'googleMail');

        const googleMailServiceSnapshot = await getDoc(googleMailServiceRef);

        if (googleMailServiceSnapshot.exists()) {
            const googleMailData = googleMailServiceSnapshot.data();
            const emails = await getEmailsFromGmail(googleMailData.token);
            return res.status(200).json({ emails });
        } else {
            return res.status(404).json({ message: 'Aucun email trouvé pour cet utilisateur.' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des emails :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}

export async function createGoogleMailWebhook(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const userId = req.user?.userId;

    try {
        const userRef = doc(db, 'users', userId);
        const googleMailServiceRef = doc(collection(userRef, 'services'), 'googleMail');
        
        const googleMailServiceSnapshot = await getDoc(googleMailServiceRef);
        const googleMailData = googleMailServiceSnapshot.data();

        await createGmailWebhook(googleMailData?.token);
        await setDoc(googleMailServiceRef, {
            webhook: true
        }, { merge: true });

        return res.status(200).json({ message: 'Webhook Google Mail créé avec succès.' });
    } catch (error) {
        console.error('Erreur lors de la création du webhook Google Mail :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}

export async function handleGoogleMailWebhookEvents(req: Request, res: Response): Promise<Response> {
    const { emailAddress, historyId, messagesAdded, messagesDeleted } = req.body;
    const action = req.headers['x-gmail-event'];

    try {
        if (action === "ping") {
            return res.status(200).send('Ping reçu avec succès.');
        }
        if (!emailAddress || !historyId) {
            return res.status(400).json({ message: 'Données manquantes dans la requête.' });
        }

        const matchingUsers = await getUsersWithGmailLogin(emailAddress);

        if (matchingUsers.length > 0) {
            for (const matchingUser of matchingUsers) {
                const userId = matchingUser.userId;
                const eventsRef = collection(doc(db, 'users', userId, "services", "googleMail"), 'events');

                const createdAt = Timestamp.fromDate(new Date());

                const googleMailEvent = {
                    emailAddress,
                    historyId,
                    messagesAdded: messagesAdded || [],
                    messagesDeleted: messagesDeleted || [],
                    createdAt,
                };

                await setDoc(doc(eventsRef), googleMailEvent);

                console.log(`Événement Google Mail sauvegardé pour l'utilisateur ${userId}`);
            }

            return res.status(200).send('Événement webhook reçu avec succès.');
        } else {
            return res.status(404).json({ message: 'Utilisateur non trouvé.' });
        }
    } catch (error) {
        console.error('Erreur lors du traitement des événements webhook Google Mail :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}
