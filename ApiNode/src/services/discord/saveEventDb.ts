import { db } from '../../init_db';
import { collection, addDoc, doc } from 'firebase/firestore';

/**
 * @description Sauvegarder un événement dans la base de données Firestore
 * @param userId L'ID de l'utilisateur lié à l'événement
 * @param eventData Les données de l'événement (contenu du message, auteur, etc.)
 */
export async function saveEventToDB(userId: string, eventData: any): Promise<void> {
  try {
    const eventsRef = collection(doc(db, 'users', userId, "services", "discord"), 'events');
    const eventsRef2 = collection(db, 'events');

    await addDoc(eventsRef, eventData);

    await addDoc(eventsRef2, eventData);

    console.log('Événement stocké dans la DB avec succès.');
  } catch (error) {
    console.error('Erreur lors du stockage de l\'événement dans la DB :', error);
  }
}
