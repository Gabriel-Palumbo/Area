import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { storeDiscordDiscordId } from './connectId';

const discordRouter = express.Router();

discordRouter.post('/store-login', tokenRequired, storeDiscordDiscordId);
// router.post('/webhook-events', handleWebhookEvents);

export default discordRouter;
