import express from 'express';
import cors from 'cors';
import { initFirebase } from './init_db';
const bodyParser = require('body-parser');
import routerservice from './services/router'
import { listenForAllUsers } from './services/listener'
import { getGoogleAuthUrl, googleAuthRedirect, login, register } from './auth/auth';
import { client } from './services/discord/action'
import { tokenChecker } from './auth/middelware';
import { handleAboutRequest } from './aboutController';
import { startTelegramPolling } from './services/telegram/listener';

const fs = require('fs');
const https = require('https');

/**
 * @description Express setup
 */
const app = express();
const PORT = process.env.PORT || 8080;

initFirebase();
app.use(cors());
app.use(bodyParser.json());

const options = {
    key: fs.readFileSync('./ssl/server.key'),
    cert: fs.readFileSync('./ssl/server.crt')
};

/**
 * @description Routes for all implemented AREA
 */
app.use('/services', routerservice);

/**
 * @description Routes for sign
 */

app.post('/login', login);

/**
 * @description Routes for register
 */

app.post('/register', register);

/**
 * @description Routes for refreshtoken
 */

app.get('/check_token', tokenChecker);

/**
 * @description Routes for about.json
 */
app.get('/about.json', handleAboutRequest);

/**
 * @description Routes pour l'authentification Google
 */
app.get('/google/auth', getGoogleAuthUrl);
app.get('/auth/google/redirect', googleAuthRedirect);


/**
 * @description Init Discord Bot
 */
const DISCORD_TOKEN = process.env.DISCORD_TOKEN;
client.login(DISCORD_TOKEN).then(() => {
  console.log('Bot Discord connecté.');
}).catch(console.error);

/**
 * @description Init Telegram Bot
 */
startTelegramPolling();


/**
 * @description Init server
 */
https.createServer(options, app).listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  listenForAllUsers();
});

export {app}
