import { doc, getDoc } from "firebase/firestore";
import { db } from "../../init_db";
import { sendMessageTelegram } from "./send_message";
import { EventData } from "../event";

export async function handleTelegramReaction(reaction: string, event: EventData) {
    if (reaction === "telegram/send_message") {
        const telegramSettingsDoc = doc(db, 'users', event.userId, "services", "telegram");
        const telegramSettingsSnapshot = await getDoc(telegramSettingsDoc);

        if (telegramSettingsSnapshot.exists()) {
            try {
                const channelId = telegramSettingsSnapshot.data()?.channelId;
                const telegramId = telegramSettingsSnapshot.data()?.telegramId;
    
                if (channelId && telegramId) {
                    const message = event.description;
                    await sendMessageTelegram(channelId, message);
                } else {
                    console.error(`Channel ID or Telegram ID missing for user ${event.userId}`);
                }
            } catch (error) {
                console.error(`Error processing reaction telegram:`, error);
            } 
        } else {
            console.error(`Telegram settings not found for user ${event.userId}`);
        }
    }
}
