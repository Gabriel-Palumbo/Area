import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { storeGitHubToken, getUserRepositories, createGitHubWebhook, handleWebhookEvents } from './githubController';

const router = express.Router();

router.post('/store-token', tokenRequired, storeGitHubToken);
router.get('/repos', tokenRequired, getUserRepositories);
router.post('/create-webhook', tokenRequired, createGitHubWebhook);
router.post('/webhook-events', handleWebhookEvents);

export default router;
