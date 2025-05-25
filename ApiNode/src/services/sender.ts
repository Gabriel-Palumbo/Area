import { doc, getDoc } from 'firebase/firestore';
import { db } from '../init_db';
import { sendMessageTelegram } from './telegram/send_message';
import { sendMessage } from './discord/action';
import { sendSlackMessage } from './slack/functions/reaction';

export async function handleEvent(userId: string, message: string, sender: string): Promise<void> {
    try {
        switch (sender) {
            case 'telegram':
                const telegramUserRef = doc(db, `users/${userId}/services/telegram`);
                const telegramUserSnapshot = await getDoc(telegramUserRef);
                if (!telegramUserSnapshot.exists()) {
                    console.log(`No Telegram configuration found for user ${userId}`);
                    return;
                }
                const telegram = telegramUserSnapshot.data();
                if (telegram.channelId) {
                    await sendMessageTelegram(telegram.channelId, message);
                } else {
                    console.error('Telegram chat ID is missing.');
                }
                break;
            case 'discord':
                const discordUserRef = doc(db, `users/${userId}/services/discord`);
                const discordUserSnapshot = await getDoc(discordUserRef);
                if (!discordUserSnapshot.exists()) {
                    console.log(`No discord configuration found for user ${userId}`);
                    return;
                }
                const discord = discordUserSnapshot.data();
                if (discord.channelId) {
                    await sendMessage(discord.channelId, message);
                } else {
                    console.error('Discord channel ID is missing.');
                }
                break;
            case 'slack':
                if (userId) {
                    await sendSlackMessage(userId, message);
                } else {
                    console.error('Slack channel ID is missing.');
                }
                break;

            default:
                console.error('Unsupported sender type:', sender);
        }
    } catch (error) {
        console.error('Error handling event:', error);
    }
}
