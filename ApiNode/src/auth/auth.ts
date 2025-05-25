import { Request, Response } from 'express';
import { collection, doc, getDoc, getDocs, query, setDoc, where } from 'firebase/firestore';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { OAuth2Client } from 'google-auth-library';
import { db } from '../init_db';
import dotenv from 'dotenv';
import axios from 'axios';
dotenv.config();

const SECRET_KEY_ENV = process.env.SECRET_KEY;

if (!SECRET_KEY_ENV) {
  throw new Error('SECRET_KEY is not defined in environment variables');
}

const SECRET_KEY = Buffer.from(SECRET_KEY_ENV, 'base64').toString('ascii');

export function getGoogleAuthUrl(req: Request, res: Response) {
  if (!process.env.CLIENT_ID || !process.env.REDIRECT_URI) {
    console.error("CLIENT_ID ou REDIRECT_URI manquant dans le fichier d'environnement.");
    return res.status(500).json({ message: "Erreur de configuration du serveur." });
  }
  try {
    const authUrl = `https://accounts.google.com/o/oauth2/v2/auth?` +
    `client_id=${process.env.CLIENT_ID}` +
    `&redirect_uri=${process.env.REDIRECT_URI}` +
    `&response_type=code` +
    `&scope=email profile` +
    `&access_type=offline`;
    return res.redirect(authUrl);
  } catch (error) {
    console.error("Erreur lors de la génération de l'URL d'authentification:", error);
    return res.status(500).json({ message: "Erreur lors de la génération de l'URL d'authentification" });
  }
}

export async function googleAuthRedirect(req: Request, res: Response) {
  const { code } = req.query;

  if (!code) {
      return res.status(400).json({
          message: 'Code d\'authentification manquant.'
      });
  }

  const params = new URLSearchParams();
  params.append('code', code as string);
  params.append('client_id', process.env.CLIENT_ID as string);
  params.append('client_secret', process.env.CLIENT_SECRET as string);
  params.append('redirect_uri', process.env.REDIRECT_URI as string);
  params.append('grant_type', 'authorization_code');

  try {
      const response = await axios.post('https://oauth2.googleapis.com/token', params);
      const { access_token } = response.data;
      
      const userInfoResponse = await axios.get('https://www.googleapis.com/oauth2/v3/userinfo', {
          headers: {
              Authorization: `Bearer ${access_token}`
          }
      });

      const userInfo = userInfoResponse.data;

      const userCollection = collection(db, "users");
      const q = query(userCollection, where('email', '==', userInfo.email));
      const querySnapshot = await getDocs(q);

      if (querySnapshot.empty) {
          await setDoc(doc(db, "users", userInfo.email), {
              email: userInfo.email,
              isBanned: false,
              firstName: userInfo.given_name || 'Mr',
              lastName: userInfo.family_name || 'Anonymous',
              picUrl: userInfo.picture || 'https://i.pinimg.com/474x/47/ba/71/47ba71f457434319819ac4a7cbd9988e.jpg',
              googleLogged: true
          });
      }

      const token = jwt.sign({ userId: userInfo.email, email: userInfo.email }, SECRET_KEY, { expiresIn: '24h' });

      return res.redirect(`http://localhost:8081/succes?token=${token}`);

  } catch (error) {
      console.error('Erreur lors de l\'authentification:', error);
      return res.status(500).json({
          message: 'Erreur lors de l\'authentification',
      });
  }
}


export async function register(req: Request, res: Response): Promise<Response> {
  const { email, password, firstNameReq, lastNameReq, picUrlReq,  } = req.body;

  let firstName = "Mr";
  let lastName = "Anonymous";
  let picUrl = "https://i.pinimg.com/474x/47/ba/71/47ba71f457434319819ac4a7cbd9988e.jpg";


  const userCollection = collection(db, "users");

  const q = query(userCollection, where('email', '==', email));
  const querySnapshot = await getDocs(q);

  if (!querySnapshot.empty) {
    return res.status(400).json({ message: 'User already exists!' });
  }

  if (!password) {
    return res.status(400).json({ message: 'Password is required to create a new account!' });
  }

  if (firstNameReq) {
    firstName = firstNameReq;
  }
  
  if (picUrlReq) {
    picUrl = picUrlReq;
  }

  if (lastNameReq) {
    lastName = lastNameReq;
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  await setDoc(doc(db, "users", email), {
    email,
    password: hashedPassword,
    isBanned: false,
    firstName,
    lastName,
    picUrl,
    googleloged:false
  });

  const token = jwt.sign({ userId: email, email: email }, SECRET_KEY, { expiresIn: '24h' });

  return res.status(201).json({ message: 'User registered successfully!', token });
}

export async function login(req: Request, res: Response): Promise<Response> {
    const { email, password } = req.body;

    const userCollection = collection(db, "users");

    const q = query(userCollection, where('email', '==', email));
    const querySnapshot = await getDocs(q);

    if (querySnapshot.empty) {
        return res.status(400).json({ message: 'User does not exist!' });
    }

    const userSnap = querySnapshot.docs[0];
    const userData = userSnap.data();

    const userId = userSnap.id;

    if (!userData.password) {
        if (!password) {
            return res.status(400).json({ message: 'Password is missing! Please provide a password.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        await setDoc(userSnap.ref, { ...userData, password: hashedPassword, isBanned: false }, { merge: true });

        const token = jwt.sign({ email }, SECRET_KEY, { expiresIn: '24h' });
        return res.status(200).json({ message: 'Password set successfully!', token });
    }

    if (!password) {
        return res.status(400).json({ message: 'Password is required to login!' });
    }

    const isPasswordValid = await bcrypt.compare(password, userData.password);
    if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid credentials!' });
    }

    const token = jwt.sign({ userId, email }, SECRET_KEY, { expiresIn: '24h' });

    return res.status(200).json({ message: 'Login successful!', token });
}
