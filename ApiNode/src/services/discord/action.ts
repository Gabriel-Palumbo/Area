import { Client, GatewayIntentBits, Events, TextChannel, Channel } from 'discord.js';

import { saveEventToDB } from './saveEventDb';
import { getDocs, collection, doc, getDoc, Timestamp } from 'firebase/firestore';
import { db } from '../../init_db';
import { getServiceReactions } from '../utils';
import { EventData } from '../event';

export const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.DirectMessages,
  ],
});

async function handleDiscordMessage(
  channelId: string,
  content: string,
  userId: string,
  description: string,
  eventType: string,
  eventId: string,
  reaction: string
) {
  const eventData : EventData = {
      name: "discord",
      description,
      userId: userId,
      eventId: eventId,
      channelId,
      createdAt: Timestamp.fromDate(new Date()),
      author: "Discord Bot",
      reaction,
      event: {
          type: eventType,
          text: content,
          channelId,
      }
  };

  await saveEventToDB(userId, eventData);
}


export async function getAllDiscordIds(): Promise<{ discordId: string, userId: string }[]> {
    const discordIds: { discordId: string, userId: string }[] = [];
  try {
    const usersSnapshot = await getDocs(collection(db, 'users'));

    for (const userDoc of usersSnapshot.docs) {
      const servicesSnapshot = await getDocs(collection(userDoc.ref, 'services'));

      for (const serviceDoc of servicesSnapshot.docs) {
        if (serviceDoc.id === 'discord') {
          const discordData = serviceDoc.data();
          if (discordData.discordId) {
            discordIds.push({ discordId: discordData.discordId, userId: userDoc.id });
          }
        }
      }
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des discordIds :', error);
  }
  return discordIds;
}

client.on(Events.MessageCreate, async (message) => {
    try {
        const discordIds = await getAllDiscordIds();

        message.mentions.users.forEach(async (mentionedUser) => {
            const discordId = mentionedUser.id;

            const discordUser = discordIds.find(d => d.discordId === discordId);
            if (discordUser) {
              
              const actionReactionMap = await getServiceReactions(discordUser.userId, 'discord');

              if (message.attachments.some(att => att.contentType?.includes("image")) && actionReactionMap["mention_photo"]) {
                  const description = `Vous avez été mentionne sur une photo de ${message.author.username} dans le salon Discord ${message.guild?.name}`;
                  await handleDiscordMessage(message.channel.id, 'mention_photo', discordUser.userId, description, "mention_photo", message.id, actionReactionMap["mention_photo"]);
              }
              
              else if (message.attachments.some(att => att.contentType?.includes("audio")) && actionReactionMap["mention_voice"]) {
                  const description = `Vous avez été mentionne sur un fichier audio de ${message.author.username} dans le salon Discord ${message.guild?.name}`;
                  await handleDiscordMessage(message.channel.id, 'mention_voice', discordUser.userId, description, "mention_voice", message.id, actionReactionMap["mention_voice"]);
              }
              
              else if (message.attachments.size > 0 && actionReactionMap["mention_file_upload"]) {
                  const description = `Vous avez été mentionn sur un fichier de ${message.author.username} dans le salon Discord ${message.guild?.name}`;
                  await handleDiscordMessage(message.channel.id, 'mention_file_upload', discordUser.userId, description, "mention_file_upload", message.id, actionReactionMap["mention_file_upload"]);
              }

              else if (actionReactionMap["mention"]) {
                  const description = `Vous avez été mentionné par ${message.author.username} dans le salon Discord ${message.guild?.name}`;
                  await handleDiscordMessage(message.channel.id, message.content, discordUser.userId, description, "mention", message.id, actionReactionMap["mention"]);
              }
            }
        });
    } catch (error) {
        console.error("Erreur lors de la gestion des mentions :", error);
    }
});

export async function sendMessage(channelId: string, content: string): Promise<void> {
  try {
    const channel = await client.channels.fetch(channelId);

    if (channel instanceof TextChannel) {
      await channel.send(content);
      console.log(`Message envoyé : ${content}`);
    } else {
      console.error('Le canal n\'est pas un canal textuel ou est introuvable.');
    }
  } catch (error) {
    console.error('Erreur lors de l\'envoi du message :', error);
  }
}

