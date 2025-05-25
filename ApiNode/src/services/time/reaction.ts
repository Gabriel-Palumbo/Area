import { doc, getDoc } from "firebase/firestore";
import { handleEvent } from "../sender";
import { db } from "../../init_db";
import { EventData } from "../event";
import { timemodel } from "./models/timemodels";
import axios from "axios";
import { Timestamp } from 'firebase/firestore';

export async function handleTimeReaction(reaction: string, event: EventData) {
    try {
        let timeData;

        if (reaction === 'time/get_current_time') {
            const docRef = doc(db, 'users', event.userId, 'services', 'time');
            const docSnapshot = await getDoc(docRef);

            if (!docSnapshot.exists()) {
                console.error(`No time service found for user ${event.userId}`);
                return;
            }
            const data = docSnapshot.data();
            timeData = await fetchCurrentTime(data?.area);
        } else {
            return;
        }

        const docRef = doc(db, 'users', event.userId, 'services', 'time');
        const docSnapshot = await getDoc(docRef);

        const data = docSnapshot.data();
        const sender = data?.sender as 'telegram' | 'discord' | 'slack';

        const message = formatTimeMessage(timeData);
        handleEvent(event.userId, message, sender);
    } catch (error) {
        console.error(`Error handling time reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}

async function fetchCurrentTime(area: string): Promise<timemodel> {
    const url = `http://worldtimeapi.org/api/timezone/${area}`;
    const response = await axios.get(url);

    if (!response.data.datetime || !response.data.timezone) {
        throw new Error('Incomplete data in API response');
    }

    const { datetime, timezone } = response.data;

    return {
        time: Timestamp.fromDate(new Date(datetime)),
        timezone: timezone,
        last_updated: Timestamp.now()
    };
}

function formatTimeMessage(timeData: timemodel): string {
    const { time, timezone, last_updated } = timeData;

    const formattedTime = new Date(time.toDate()).toLocaleString('fr-FR', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
    });

    let message = `🕒 **Heure actuelle : ${formattedTime}**\n`;
    message += `🌍 **Fuseau horaire : ${timezone}**\n`;
    message += `🕒 **Dernière mise à jour : ${new Date(last_updated.toDate()).toLocaleString('fr-FR')}**`;

    return message;
}

