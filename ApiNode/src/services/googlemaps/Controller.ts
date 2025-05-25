import { Request, Response } from 'express';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '../../init_db';
import axios from 'axios';
import { AuthenticatedRequest } from '../../auth/middelware';

export const calculateTravelTime = async (req: AuthenticatedRequest, res: Response): Promise<Response> => {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(401).json({ error: 'user non' });
        }

        const userDocRef = doc(db, 'users', userId, 'services', 'googlemap');
        const userDoc = await getDoc(userDocRef);

        if (!userDoc.exists()) {
            return res.status(404).json({ error: 'Travel data not found for this user' });
        }
        
        const userData = userDoc.data();
        const { origin, destination, sender, apikey } = userData;
        
        if (!origin || !destination || !apikey) {
            return res.status(400).json({ error: 'Origin, destination, and API key must be set in user data' });
        }

        const url = `https://maps.googleapis.com/maps/api/distancematrix/json?origins=${encodeURIComponent(
            origin
        )}&destinations=${encodeURIComponent(destination)}&key=${apikey}`;

        const response = await axios.get(url);
        const data = response.data; 

        if (data.status !== 'OK') {
            return res.status(500).json({ error: 'Failed to retrieve data from Google Maps API' });
        }

        const travelInfo = data.rows[0].elements[0];

        if (travelInfo.status !== 'OK') {
            return res.status(404).json({ error: 'No route found' });
        }

        const summary = `Votre trajet programmé de ${data.origin_addresses[0]} pour ${data.destination_addresses[0]} vous prendra ${travelInfo.duration.text} (${travelInfo.distance.text}).`;

        return res.status(200).send(summary);
    } catch (error) {
        console.error('Error calculating travel time:', error);
        return res.status(500).json({ error: 'Server error' });
    }
};
