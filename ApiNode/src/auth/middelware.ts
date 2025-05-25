import { Request, Response, NextFunction } from 'express';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { findUserByEmail } from './finduser';
import dotenv from 'dotenv';
dotenv.config();

const SECRET_KEY_ENV = process.env.SECRET_KEY;

if (!SECRET_KEY_ENV) {
  throw new Error('SECRET_KEY is not defined in environment variables');
}

const SECRET_KEY = Buffer.from(SECRET_KEY_ENV, 'base64').toString('ascii');

export interface AuthenticatedRequest extends Request {
  user?: JwtPayload;
}

export function tokenRequired(
  req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ message: 'Token is missing!' });
  }

  try {
    const bearerToken = token.split(' ')[1];
    const decoded = jwt.verify(bearerToken, SECRET_KEY) as JwtPayload;
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ error: error });
  }
}

export function tokenChecker(req: Request, res: Response): Response {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ message: 'Token is missing!' });
  }

  try {
    const bearerToken = token.split(' ')[1];

    const decoded = jwt.verify(bearerToken, SECRET_KEY) as JwtPayload;
    const newToken = jwt.sign({ userId: decoded.userId }, SECRET_KEY, { expiresIn: '24h' });
    return res.status(200).json({ newToken });
  } catch (error) {
    return res.status(403).json({ error: 'Invalid token' });
  }
}


export async function adminRequired(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  if (!req.user || !req.user.email) {
    return res.status(403).json({ message: 'User email is missing!' });
  }
  try {
    const userData = await findUserByEmail(req.user.email);

    if (!userData || !userData.isAdmin) {
      return res.status(403).json({ message: 'Admin privileges are required!' });
    }

    next();
  } catch (error) {
    console.error('Error verifying admin:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}

export async function verifAdmin(req: AuthenticatedRequest, res: Response) {
  if (!req.user || !req.user.email) {
    return res.status(403).json({ message: 'User email is missing!' });
  }

  try {
    const userData = await findUserByEmail(req.user.email);

    if (!userData || !userData.isAdmin) {
      return res.status(200).json({ isAdmin: false });
    }

    return res.status(200).json({ isAdmin: true });
  } catch (error) {
    console.error('Error verifying admin:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
