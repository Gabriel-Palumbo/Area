import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { saveTokenSender } from './action';

const weatherRouter = express.Router();

weatherRouter.post('/save_ville_token', tokenRequired, saveTokenSender);
// weatherRouter.get('/current', tokenRequired, getCurrentWeather);
// weatherRouter.get('/forecast', tokenRequired, getForecast);
// weatherRouter.get('/history', tokenRequired, getHistory);
// weatherRouter.get('/astronomy', tokenRequired, getAstronomy);

export default weatherRouter;
