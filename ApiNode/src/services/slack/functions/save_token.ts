import { Request, Response } from 'express';
import { collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../../init_db';
import { AuthenticatedRequest } from '../../../auth/middelware';

export async function saveToken(req: AuthenticatedRequest, res: Response): Promise<Response>  {
   try {
     const slackToken = req.body.token;
     const memberId = req.body.memberId;
     const email = req.user?.userId;
 
     const usersRef = collection(db, 'users');
 
     const q = query(usersRef, where('email', '==', email));
 
     const userSnapshot: QuerySnapshot<DocumentData> = await getDocs(q);  
     if (userSnapshot.empty) {
         console.log('(Slack - saveToken) No user document found.');
         return res.status(500).send('(Slack - saveToken) Server Error : No user document found.');
     }

     const userDoc = userSnapshot.docs[0];
     const slackDocRef = doc(db, `users/${userDoc.id}/services`, 'slack');
 
     await setDoc(slackDocRef, { token: slackToken, member_id: memberId }, { merge: true });
 
     return res.status(200).send('(Slack - saveToken) Token saved succefully');
   } catch (error) {
        return res.status(500).send('(Slack - saveToken) Server Error: when trying to save the slack Token');
   }
}
