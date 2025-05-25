import { Request, Response } from 'express';
import { addDoc, collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../../../init_db';
import { AuthenticatedRequest } from '../../../../auth/middelware';
import { getUserByID } from '../../../../auth/get_user_by_id';

import 'axios';
import axios from 'axios';


/**
 * @description Send slack message using incoming-webhook 
 * 
 * @param req.user.userId
 */
export async function sendSlackMessage(req: AuthenticatedRequest, res: Response) {
    try {
        const userId = req.user?.userId;

        const slackUserRef = doc(db, `users/${userId}/services/slack`);
        const slackUserSnapshot = await getDoc(slackUserRef);

        const slackUserData = slackUserSnapshot.data();
        const slackIncomingWebhookUrl = slackUserData!.slack_incoming_webhook

        const response = await axios.post(slackIncomingWebhookUrl, {
            text: "(sendSlackMessage) My Personnalize Message ..."
          }, {
            headers: {
              'Content-Type': 'application/json'
            }
          });

        return res.status(200).send("(sendSlackMessage) Message sent to slack succeffuly");
    } catch (error) {
        console.log("(sendSlackMessage) ")
        return res.status(500).send("(sendSlackMessage) Error Sending message to slack using slack incoming webhook ");
    }
}
