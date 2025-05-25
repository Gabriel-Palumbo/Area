import firebase from 'firebase/compat/app';
import 'firebase/compat/firestore';
import 'firebase/compat/storage';
import { logs } from '../logs/logs';

interface User {
  id: string;
  email: string;
  name: string;
  surname: string;
  birth_date: string;
  gender: string;
  work: string;
  profilePhotoUrl?: string;
  coverPhotoUrl?: string;
}
