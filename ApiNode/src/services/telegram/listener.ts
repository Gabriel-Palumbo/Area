import { collection, doc, getDoc, getDocs, query, setDoc, where, writeBatch } from 'firebase/firestore';
import { db } from '../../init_db';
import { handleTelegramMessage } from './events';
import { getServiceReactions } from '../utils';
import { sendMessageTelegram } from './send_message';
import { DiagConsoleLogger } from '@google-cloud/logging-min';

const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;

export const TELEGRAM_API_URL = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}`;

interface TelegramUser {
    userId: string;
    telegramId: number;
    offset: number;
    chanelId: number | null;
    awaitingChannelMention?: boolean;
}

type UsersMap = Record<number, TelegramUser>;

async function getTelegramUsers(): Promise<UsersMap> {
    const usersSnapshot = await getDocs(collection(db, 'users'));
    const users: UsersMap = {};

    for (const userDoc of usersSnapshot.docs) {
        const servicesSnapshot = await getDocs(collection(userDoc.ref, 'services'));

        for (const serviceDoc of servicesSnapshot.docs) {
            if (serviceDoc.id === 'telegram') {
                const telegramData = serviceDoc.data();
                if (telegramData.telegramId) {
                    const telegramId = telegramData.telegramId;
                    const userId = userDoc.id;

                    users[telegramId] = {
                        userId,
                        telegramId,
                        offset: telegramData.offset || 0,
                        awaitingChannelMention: telegramData.awaitingChannelMention,
                        chanelId: telegramData.channelId || null,
                    };
                }
            }
        }
    }

    return users;
}

function isUserMentioned(update: any, telegramId: number): boolean {
    if (update.message?.entities) {
        for (const entity of update.message.entities) {
            if (entity.type === 'text_mention' && entity.user?.id === telegramId) {
                return true;
            }
        }
    }
    return false;
}



async function storeChannelIdAndBatchUpdate(updates: Array<any>) {
    const batch = writeBatch(db);
    const users : UsersMap = await getTelegramUsers();

    for (const update of updates) {
        const telegramId = update.message?.from?.id;
        const chatId = update.message?.chat?.id;

        if (telegramId && users[telegramId] && users[telegramId].offset <= update.update_id) {
            const user = users[telegramId];
            user.offset = update.update_id + 1;

            if (update.message?.text?.includes('@area_allo_poulet_bot') && user.awaitingChannelMention == true) {
                const telegramServiceRef = doc(db, `users/${user.userId}/services/telegram`);
                
                batch.set(
                    telegramServiceRef,
                    { channelId: chatId, awaitingChannelMention: false, offset: user.offset },
                    { merge: true }
                );
            }

            const actionReactionMap = await getServiceReactions(user.userId, 'telegram');

            if (user.awaitingChannelMention == false && isUserMentioned(update, telegramId) && actionReactionMap["mention"]) {
                const description = `vous avez été mentionner par ${update.message.from.first_name} ${update.message.from.last_name} dans la salon telegram ${update.message.chat.title}`;
                handleTelegramMessage(chatId, update.message?.text, user.userId, description, "mention", update.update_id, actionReactionMap["mention"]);
            }

            if (user.awaitingChannelMention == false && update.message?.document && chatId === user.chanelId && actionReactionMap["file_upload"]) {
                const description = `vous avez reçu un fichier par ${update.message.from.first_name} ${update.message.from.last_name} dans la salon telegram ${update.message.chat.title}`;
                handleTelegramMessage(chatId, update.message?.document.file_name, user.userId, description, "file_upload", update.update_id, actionReactionMap["file_upload"]);
            }

            if (user.awaitingChannelMention == false && update.message?.photo && actionReactionMap["photo"]) {
                const description = `vous avez reçu une photo par ${update.message.from.first_name} ${update.message.from.last_name} dans la salon telegram ${update.message.chat.title}`;
                handleTelegramMessage(chatId, 'photo', user.userId, description, "photo", update.update_id, actionReactionMap["photo"]);
            }

            if (user.awaitingChannelMention == false && update.message?.voice && actionReactionMap["voice"]) {
                const description = `vous avez reçu un message vocal par ${update.message.from.first_name} ${update.message.from.last_name} dans la salon telegram ${update.message.chat.title} qui a duré ${update.message?.voice.duration}`;
                handleTelegramMessage(chatId, 'voice', user.userId, description, "voice", update.update_id, actionReactionMap["voice"]);
            }

            if (user.awaitingChannelMention == false) {
                const telegramServiceRef = doc(db, `users/${user.userId}/services/telegram`);
                batch.set(telegramServiceRef, { offset: user.offset }, { merge: true });
            }
        }
    }

    await batch.commit();
}

export async function startTelegramPolling() {
    const users = await getTelegramUsers();
    let offset = Math.min(...Object.values(users).map(user => user.offset));

    while (true) {
        console.log("telegram pour faire attention");
        const response = await fetch(`${TELEGRAM_API_URL}/getUpdates?offset=${offset}`);
        const data = await response.json();

        if (data.ok && data.result.length > 0) {
            await storeChannelIdAndBatchUpdate(data.result);
        }

        await new Promise(resolve => setTimeout(resolve, 60000));
    }
}
