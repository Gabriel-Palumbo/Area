import { app } from '../../server';
import { createSlackWebhook } from './functions/create_slack_webhook';
import { saveToken } from './functions/save_token';
import { Router, Request, Response } from 'express';
import { sendSlackMessage } from './functions/reactions/send_slack_message';
import { tokenRequired } from '../../auth/middelware';
import { saveSlackIncomingWebhook } from './functions/save_slack_incoming_webhook';

const router = Router();

/**
 * @description [Slack] Setup du token de l'AppSlack (bot) ajouté à la workspace
 * 
 */
router.post('/save-token', tokenRequired, saveToken);

/**
 * @description [Slack] Setup du token de l'AppSlack (bot) ajouté à la workspace
 * 
 */
router.post('/save-incoming-webhook', tokenRequired, saveSlackIncomingWebhook);

/**
 * @description [Slack] Webhook
 *
 */
router.post('/event-received', createSlackWebhook);

/**
 * @description [Slack] Reaction Send Message
 *
 */
router.post('/send-message', tokenRequired, sendSlackMessage);


export default router;
