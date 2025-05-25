import express from 'express';
import { tokenRequired } from '../../auth/middelware';
import { saveSender } from './save';

const newsRouter = express.Router();

newsRouter.post('/save_sender', tokenRequired, saveSender);

export default newsRouter;

