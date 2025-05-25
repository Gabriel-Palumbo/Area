import { Response } from 'express';
import { collection, deleteDoc, doc, getDoc, getDocs, query, setDoc, updateDoc, where } from 'firebase/firestore';
import { AuthenticatedRequest } from '../auth/middelware';
import { db } from '../init_db';

export async function handleUserAction(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const { email, action } = req.body;

        const userQuery = query(collection(db, 'customers'), where('email', '==', email));
        const userSnapshot = await getDocs(userQuery);

        if (userSnapshot.empty) {
            return res.status(404).json({ message: 'User not found!' });
        }

        const userDoc = userSnapshot.docs[0];
        const customerId = userDoc.id;
        const firestoreUserRef = doc(db, 'customers', customerId);

        if (action === 'delete') {
            await deleteDoc(firestoreUserRef);
            return res.status(200).json({ message: `User ${email} has been deleted from Firestore.` });
        } else if (action === 'ban') {
            await updateDoc(firestoreUserRef, { isBanned: true });
            return res.status(200).json({ message: `User ${email} has been banned in Firestore.` });
        } else if (action === 'deban') {
            await updateDoc(firestoreUserRef, { isBanned: false });
            return res.status(200).json({ message: `User ${email} has been debanned in Firestore.` });
        } else {
            return res.status(400).json({ message: 'Invalid action! Please specify either "delete", "ban", or "deban".' });
        }
    } catch (error) {
        console.error('Error handling user action:', error);
        return res.status(500).json({ message: 'Error handling user action.', error });
    }
}
