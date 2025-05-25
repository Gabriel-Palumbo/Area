import express from 'express';
import { RrefreshLeaugue1, getTodayMatches,getLastMatch_L1,getLastMatch_L2,getLastMatch_L3 ,getLastMatch_L4,getLastMatch_L5} from './controller';
import { tokenRequired } from '../../auth/middelware';
import { saveSender } from './save';

const footrouter = express.Router();

footrouter.post('/save_sender', tokenRequired, saveSender);

footrouter.post('/getLastL1', getLastMatch_L1)
footrouter.post('/getLastL2', getLastMatch_L2)
footrouter.post('/getLastL3', getLastMatch_L3)
footrouter.post('/getLastL4', getLastMatch_L4)
footrouter.post('/getLastL5', getLastMatch_L5)

export default footrouter;