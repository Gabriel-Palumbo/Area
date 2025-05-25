import express from 'express';
import {GetNinjaQuotes} from './controler';
import { tokenRequired } from '../../auth/middelware';
import { saveSender } from './save';

const ninjasrouter = express.Router();

ninjasrouter.post('/save_sender', tokenRequired, saveSender);

ninjasrouter.post('/getquotes', GetNinjaQuotes);

export default ninjasrouter;