import { Timestamp } from 'firebase/firestore';

export interface timemodel {
    time: Timestamp;
    timezone: string;
    last_updated: Timestamp;
}
