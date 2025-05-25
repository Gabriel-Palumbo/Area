import { Request, Response } from 'express';
import { addDoc, collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, updateDoc, where } from 'firebase/firestore';
import { db } from '../../../init_db';
import { SlackEvent } from '../models/model';
import { AuthenticatedRequest } from '../../../auth/middelware';

/**
 * @description Save Slack link to send message from AREA App to Slack
 * 
 * @param req.user.userId
 * @param req.body.slack_incoming_webhook
 */
export async function saveSlackIncomingWebhook(req: AuthenticatedRequest, res: Response) {
    try {
        const userId = req.body.userId;
        const slackIncomingWebhook = req.body.slack_incoming_webhook;

        const userSlackRef = doc(db, `users/${userId}/services/slack`);
        if (!userSlackRef) {
            throw new Error("(saveSlackIncomingWebhook) Error: save the slack incoming webhook.");
        }

        await updateDoc(userSlackRef, { slack_incoming_webhook: slackIncomingWebhook });
        res.status(200).send("Incoming Webhook Url saved succeffuly");        
    } catch (error) {
        console.log("(saveSlackIncomingWebhook) Error: save the slack incoming webhook.")
        res.status(500).send("(saveSlackIncomingWebhook) Error: save the slack incoming webhook.");
    }
}
