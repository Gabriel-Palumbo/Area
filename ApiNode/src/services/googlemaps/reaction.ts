import { doc, getDoc } from "firebase/firestore";
import axios from "axios";
import { db } from "../../init_db";
import { handleEvent } from "../sender";
import { EventData } from "../event";

async function calculateTravelTime(userId: string): Promise<string | null> {
    const userDocRef = doc(db, 'users', userId, 'services', 'googlemap');
    const userDoc = await getDoc(userDocRef);

    if (!userDoc.exists()) {
        console.warn(`Travel data not found for user ${userId}`);
        return null;
    }
    
    const userData = userDoc.data();
    const { origin, destination, apikey } = userData;
    
    if (!origin || !destination || !apikey) {
        console.warn('Origin, destination, and API key must be set in user data');
        return null;
    }

    const url = `https://maps.googleapis.com/maps/api/distancematrix/json?origins=${encodeURIComponent(
        origin
    )}&destinations=${encodeURIComponent(destination)}&key=${apikey}`;

    const response = await axios.get(url);
    const data = response.data; 

    if (data.status !== 'OK') {
        console.warn('Failed to retrieve data from Google Maps API');
        return null;
    }

    const travelInfo = data.rows[0].elements[0];

    if (travelInfo.status !== 'OK') {
        console.warn('No route found');
        return null;
    }

    return `Votre trajet programmé de ${data.origin_addresses[0]} pour ${data.destination_addresses[0]} vous prendra ${travelInfo.duration.text} (${travelInfo.distance.text}).`;
}

export async function handleTravelTimeReaction(reaction: string, event: EventData) {
    try {
        if (reaction != "googlemap/get_travel_time") {
            return;
        }
        
        const userId = event.userId;
        const travelTimeMessage = await calculateTravelTime(userId);

        if (!travelTimeMessage) {
            console.warn(`No travel time data found for user ${userId}`);
            return;
        }

        const docRef = doc(db, 'users', userId, 'services', 'googlemap');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            console.error(`No google map service found for user ${userId}`);
            return;
        }

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';

        handleEvent(userId, travelTimeMessage, sender);
    } catch (error) {
        console.error(`Error handling travel time reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}
