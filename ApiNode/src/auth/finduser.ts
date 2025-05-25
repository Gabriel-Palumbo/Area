import { collection, query, where, getDocs, QuerySnapshot, DocumentData } from 'firebase/firestore';
import { db } from '../init_db';

export async function findUserByEmail(email: string): Promise<DocumentData | null> {
    const findInCollection = async (collectionName: string): Promise<DocumentData | null> => {
        const collectionRef = collection(db, collectionName);
        const queryRef = query(collectionRef, where('email', '==', email));
        const snapshot: QuerySnapshot<DocumentData> = await getDocs(queryRef);

        if (!snapshot.empty) {
            return snapshot.docs[0].data();
        } else {
            return null;
        }
    };

    let userData = await findInCollection('customers');

    if (!userData) {
        userData = await findInCollection('employee');
    }

    if (userData) {
        return userData;
    } else {
        return null;
    }
}


