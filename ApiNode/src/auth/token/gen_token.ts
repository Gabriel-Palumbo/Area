import jwt from 'jsonwebtoken';

const SECRET_KEY = process.env.SECRET_KEY || 'your_secret_key';

export function generateToken(email: string): string {
  const token = jwt.sign(
    { email: email },
    SECRET_KEY,
    { expiresIn: '1h' }
  );
  return token;
}
