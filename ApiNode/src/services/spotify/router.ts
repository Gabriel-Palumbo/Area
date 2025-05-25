import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { storeSpotifyToken} from './action';

const spotifyRouter = express.Router();

spotifyRouter.post('/store-spotify-token', tokenRequired, storeSpotifyToken);

export default spotifyRouter;
