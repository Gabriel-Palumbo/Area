import { Request, Response } from 'express';
import { findUserSlackToken } from './check_slack_token';
import { saveSlackEvent } from './save_slack_events';

export async function createSlackWebhook(req: Request, res: Response) {
    try {
        const slackEvent = req.body;
        console.log('Webhook triggered!');

        if (slackEvent.type === 'url_verification') {
          res.status(200).send(slackEvent.challenge);
        } else {
          const userId = await findUserSlackToken(slackEvent.token);
          if (!userId) {
            res.status(400).send('An error occured during the Slack webhook.');
            return;
          }

          const saveRet = await saveSlackEvent(slackEvent, userId);
          if (!saveRet) {
            throw new Error("Impossible to save the new slack event in the 'events' collection");
          }
          res.status(200).send('Event received');
        }
      } catch (error) {
        res.status(400).send('An error occured during the Slack webhook.');
      }
}
