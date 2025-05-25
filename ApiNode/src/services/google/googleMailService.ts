import { doc, setDoc, getDoc, collection, Timestamp, query,getDocs, where } from 'firebase/firestore';
import { db } from '../../init_db';


export async function getGmailUserByToken(token: string): Promise<any> {
    const userInfoEndpoint = 'https://www.googleapis.com/oauth2/v3/userinfo';

    try {
        const response = await fetch(userInfoEndpoint, {
            method: 'GET',
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });

        if (!response.ok) {
            throw new Error(`Erreur HTTP : ${response.status}`);
        }

        const userInfo = await response.json();
        return userInfo;
    } catch (error) {
        console.error('Erreur lors de la récupération des informations utilisateur Gmail :', error);
        throw new Error('Impossible de récupérer les infos utilisateur Gmail');
    }
}


export async function saveGoogleMailUserToDB(userId: string, userData: any): Promise<void> {
    try {
        const userRef = doc(db, 'users', userId);
        const googleMailServiceRef = doc(collection(userRef, 'services'), 'googleMail');
        
        await setDoc(googleMailServiceRef, userData, { merge: true });
        console.log(`Utilisateur Gmail sauvegardé avec succès pour l'ID utilisateur ${userId}`);
    } catch (error) {
        console.error('Erreur lors de la sauvegarde de l\'utilisateur Gmail dans Firestore :', error);
        throw new Error('Erreur lors de la sauvegarde de l\'utilisateur Gmail');
    }
}

export async function getEmailsFromGmail(token: string): Promise<any[]> {
    const gmailApiEndpoint = 'https://gmail.googleapis.com/gmail/v1/users/me/messages';

    try {
        const response = await fetch(gmailApiEndpoint, {
            method: 'GET',
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });

        if (!response.ok) {
            throw new Error(`Erreur HTTP : ${response.status}`);
        }

        const data = await response.json();
        
        const messages = data.messages || [];

      
        const detailedMessages = await Promise.all(messages.map(async (message: any) => {
            const messageDetailResponse = await fetch(`${gmailApiEndpoint}/${message.id}`, {
                method: 'GET',
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });

            if (!messageDetailResponse.ok) {
                throw new Error(`Erreur HTTP lors de la récupération du message ${message.id} : ${messageDetailResponse.status}`);
            }

            return await messageDetailResponse.json();
        }));

        return detailedMessages;
    } catch (error) {
        console.error('Erreur lors de la récupération des emails Gmail :', error);
        throw new Error('Impossible de récupérer les emails Gmail');
    }
}


export async function createGmailWebhook(token: string): Promise<void> {
    const gmailWatchEndpoint = 'https://gmail.googleapis.com/gmail/v1/users/me/watch';

    try {
        const requestBody = {
            labelIds: ['INBOX'],
            topicName: 'projects/booming-edge-437921-k0/topics/gmail-notifications.',
        };

        const response = await fetch(gmailWatchEndpoint, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(requestBody),
        });

        if (!response.ok) {
            throw new Error(`Erreur HTTP : ${response.status}`);
        }

        console.log('Webhook Gmail créé avec succès.');
    } catch (error) {
        console.error('Erreur lors de la création du webhook Gmail :', error);
        throw new Error('Impossible de créer le webhook Gmail');
    }
}


export async function getUsersWithGmailLogin(emailAddress: string): Promise<any[]> {
    try {
        const usersRef = collection(db, 'users');

        const q = query(usersRef, where('email', '==', emailAddress));

        const querySnapshot = await getDocs(q);

        const users = querySnapshot.docs.map(doc => doc.data());

        return users;
    } catch (error) {
        console.error('Erreur lors de la récupération des utilisateurs avec le login Gmail :', error);
        throw new Error('Impossible de trouver les utilisateurs avec ce login Gmail');
    }
}