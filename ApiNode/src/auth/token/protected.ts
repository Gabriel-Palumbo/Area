import { Request, Response } from 'express';
import { AuthenticatedRequest } from '../middelware'; // Assurez-vous que AuthenticatedRequest est exporté
import { doc, getDoc } from 'firebase/firestore';
import { db } from '../../init_db';

export async function protectedRoute(req: AuthenticatedRequest, res: Response): Promise<Response> {
  const email = req.user?.email;

  if (!email) {
    return res.status(403).json({ message: 'No email found in token!' });
  }

  const userRef = doc(db, 'customers', email);
  const userSnap = await getDoc(userRef);

  if (!userSnap.exists()) {
    return res.status(404).json({ message: 'User not found!' });
  }

  const user = userSnap.data();
  return res.status(200).json({ user });
}
