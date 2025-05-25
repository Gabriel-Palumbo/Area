import { db } from '../../init_db';
import { collection, addDoc, doc, Timestamp } from 'firebase/firestore';
import { EventData } from '../event';


export async function handleTelegramMessage(
    chatId: number, message: string, userId: string,
    description: string, type: string, eventId: number, reaction: any) {
    const eventData : EventData = {
        name: "telegram",
        description: description,
        userId: userId,
        eventId: String(eventId),
        createdAt: Timestamp.fromDate(new Date()),
        reaction: reaction,
        event: {
            type: type,
            text: message,
            channelId: String(chatId),
        },
        channelId: String(chatId),
        author: 'bot telegram',
    };

    await saveEventToDB(userId, eventData);
}

async function saveEventToDB(userId: string, eventData: any): Promise<void> {
    try {
        const eventsRef = collection(doc(db, 'users', userId, "services", "telegram"), 'events');
        const eventsRef2 = collection(db, 'events');

        await addDoc(eventsRef, eventData);

        await addDoc(eventsRef2, eventData);

    } catch (error) {
        console.error('Erreur lors du stockage de l\'événement Telegram dans la DB :', error);
    }
}
