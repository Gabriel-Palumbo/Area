import { Request, Response } from 'express';
import { collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../../init_db';

/**
 * @description This function check if the slack App token get by the event
 * belongs to someone. If yes, it return the user id.
 * 
 * @param slackToken 
 * @returns user.id
 */
export async function findUserSlackToken(slackToken: string) {
    try {
      const usersSnapshot = getDocs(collection(db, 'users'));

      for (const userDoc of (await usersSnapshot).docs) {
        const slackDocRef = doc(db, `users/${userDoc.id}/services`, 'slack');
        const slackDoc = await getDoc(slackDocRef);
        if (slackDoc.exists()) {
          const slackData = slackDoc.data();
          if (slackData?.token === slackToken) {
            return userDoc.id;
          }
        }
      }
    } catch (error) {
        console.log("Error: find user slack token ")
        return null;
    }
}
