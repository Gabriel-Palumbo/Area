import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { saveSender } from './save';
// import { getBitCoinInfos, getEthereumInfos, getSolanaInfos, getTetherInfos } from './coinmarketcap';

const coinRouter = express.Router();

coinRouter.post('/save_sender', tokenRequired, saveSender);


export default coinRouter;
