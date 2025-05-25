import express from 'express';
import githubRouter from './github/router';
import slackRoutes from './slack/routes';
import discordRouter from './discord/router';
import { tokenRequired } from '../auth/middelware';
import {getAccountInfo, getUserServicesRoute, getUserEventsSorted, getUserServicesRouteSimple, deleteService, getUserServicesConnect } from './list';
import { createAreaRoute, deleteAreaRoute } from './act_to_react';
import spotifyRouter from './spotify/router';
//import zoomRouter from './zoom/router';
import telegramRouter from './telegram/router';
import weatherRouter from './weather/router';
import footrouter from './football/router';
import timerouter from './time/router';
import newsRouter from './mediastack/router';
import coinRouter from './coinmarketcap/router';
import ninjasrouter from './ninja/router';
import marketRouter from './finnhub/routes';
import mapsrouter from './googlemaps/route';

const router = express.Router();

router.get('/user/info', tokenRequired, getAccountInfo);

router.get('/list_service', tokenRequired, getUserServicesRoute);

router.get('/list_service_simple', tokenRequired, getUserServicesRouteSimple);

router.get('/list_service_connected', tokenRequired, getUserServicesConnect);

router.get('/recent_event', tokenRequired, getUserEventsSorted);

router.post('/add_action_reaction', tokenRequired, createAreaRoute);

router.delete('/delete_action_reaction', tokenRequired, deleteAreaRoute);

router.delete('/delete_service', tokenRequired, deleteService);


/**
 * @description [time] Routes
 */
router.use('/time', timerouter);

/**
 * @description [Github] Routes
 */
router.use('/github', githubRouter);

/**
 * @description [Slack] Routes 
 */
router.use('/slack', slackRoutes);

/**
 * @description [Discord] Routes
 */
router.use('/discord', discordRouter);

/**
 * @description [Zoom] Routes
 */
//router.use('/zoom', zoomRouter);

/**
 * @description [Telegram] Routes
 */
router.use('/telegram', telegramRouter);

/**
 * @description [Weather] Routes
 */
router.use('/weather', weatherRouter);

/**
 * @description [Coin Market Cap] Routes
 */
router.use('/coincap', coinRouter);

router.use('/spotify', spotifyRouter);

router.use('/football', footrouter);

router.use('/news', newsRouter);

router.use('/quotes', ninjasrouter);

router.use('/stock', marketRouter);

router.use('/maps', mapsrouter);

export default router;
