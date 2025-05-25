
import { initializeApp, FirebaseApp } from "firebase/app";
import { getFirestore, Firestore } from "firebase/firestore";
import { getStorage, FirebaseStorage } from "firebase/storage";


const firebaseConfig = {

  apiKey: "AIzaSyDvQaTzGF1cwor46dkMJc42OXwZBf-VGTU",

  authDomain: "area-2-e77d3.firebaseapp.com",

  projectId: "area-2-e77d3",

  storageBucket: "area-2-e77d3.firebasestorage.app",

  messagingSenderId: "308583846363",

  appId: "1:308583846363:web:18fc917317fcf1051057fe"

};

  
let app: FirebaseApp;
let db: Firestore;
let storage: FirebaseStorage;

export function initFirebase(): void {
  app = initializeApp(firebaseConfig);
  db = getFirestore(app);
  storage = getStorage(app);
}

export { db, storage };
