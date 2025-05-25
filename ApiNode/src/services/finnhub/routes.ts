import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { getAppleInfo, getGMInfo, getGoogleInfo, getTeslaInfo, getFacebookInfo,getMicrosoftInfo } from './controler';
import { saveSender } from './save';

const marketRouter = express.Router();

marketRouter.post('/save_token', tokenRequired, saveSender);

export default marketRouter;
