import axios from "axios";
import { db } from "../../../init_db";
import { doc, getDoc } from "firebase/firestore";
import { EventData } from "../../event";

export async function handleSlackReaction(reaction: string, event: EventData) {
    if (reaction === "slack/send_message") {
        try {
            const userId = event.userId;
            const slackUserRef = doc(db, `users/${userId}/services/slack`);
            const slackUserSnapshot = await getDoc(slackUserRef);
    
            if (!slackUserSnapshot.exists()) {
                console.log(`No Slack configuration found for user ${userId}`);
                return;
            }
    
            const slackUserData = slackUserSnapshot.data();
            const slackIncomingWebhookUrl = slackUserData?.slack_incoming_webhook;
    
            if (!slackIncomingWebhookUrl) {
                console.log(`Slack webhook URL not set for user ${userId}`);
                return;
            }
    
            const messageText = `(handleSlackReaction) Event detected: ${event.description}`;
            
            await axios.post(slackIncomingWebhookUrl, {
                text: messageText
            }, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });
    
            console.log(`Slack message sent successfully for user ${userId}`);
        } catch (error) {
            console.error(`(handleSlackReaction) Error sending message to Slack for user ${event.userId}:`, error);
        }
    }
}

export async function sendSlackMessage(userId: string, message: string) {
    try {
        const slackUserRef = doc(db, `users/${userId}/services/slack`);
        const slackUserSnapshot = await getDoc(slackUserRef);

        if (!slackUserSnapshot.exists()) {
            console.log(`No Slack configuration found for user ${userId}`);
            return;
        }

        const slackUserData = slackUserSnapshot.data();
        const slackIncomingWebhookUrl = slackUserData?.slack_incoming_webhook;

        if (!slackIncomingWebhookUrl) {
            console.log(`Slack webhook URL not set for user ${userId}`);
            return;
        }

        
        await axios.post(slackIncomingWebhookUrl, {
            text: message
        }, {
            headers: {
                'Content-Type': 'application/json'
            }
        });

        console.log(`Slack message sent successfully for user ${userId}`);
    } catch (error) {
        console.error(`(handleSlackReaction) Error sending message to Slack for user ${userId}:`, error);
    }
}
