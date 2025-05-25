//  // Créer une référence au document dans la collection 'users'
//  const userDocRef = doc(db, "users", userId);
    
//  // Utiliser getDoc pour récupérer le document
//  const userSnapshot = await getDoc(userDocRef);

import { Request, Response } from 'express';
import { addDoc, collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../init_db';

/**
 * @description 
 * 
 * 
 */
export async function getUserByID(userId: string) {
    try {
        // Créer une référence au document dans la collection 'users'
        const userDocRef = doc(db, "users", userId);
    
        // Utiliser getDoc pour récupérer le document
        const userSnapshot = await getDoc(userDocRef);

        if (!userSnapshot.exists()) {
            throw new Error("(getUserByID) Error retrieving user data");
        }

        return userSnapshot.data();
    } catch (error) {
        console.log("(getUserByID) Error retrieving user data")
        return false;
    }
}
