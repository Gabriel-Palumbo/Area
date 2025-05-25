import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { storeRevolutToken } from './action';

const revolutRouter = express.Router();

revolutRouter.post('/store-revolut-token', tokenRequired, storeRevolutToken);


export default revolutRouter;
