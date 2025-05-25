import { doc, getDoc } from 'firebase/firestore';
import { db } from '../../init_db';
import { sendMessage } from './action';
import { EventData } from '../event';

export async function handleDiscordReaction(reaction: string, event: EventData) {
  if (reaction === "discord/send_message") {
    try {
      const discordSettingsDoc = doc(db, 'users', event.userId, 'services', 'discord');
      const discordSettingsSnapshot = await getDoc(discordSettingsDoc);
    
      if (discordSettingsSnapshot.exists()) {
          const channelId = discordSettingsSnapshot.data()?.channelId;
          const discordId = discordSettingsSnapshot.data()?.discordId;
    
          if (channelId && discordId) {
              await sendMessage(channelId, event.description);
          } else {
              console.error(`Discord channelId or discordId is missing for user ${event.userId}`);
          }
      } else {
          console.error(`Discord settings not found for user ${event.userId}`);
      }
    } catch (error) {
      console.error(error);
    }
  }
}
