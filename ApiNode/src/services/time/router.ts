import express from 'express';
import {GetTime} from './controller';
import { saveAreaSender } from './save';
import { TokenExpiredError } from 'jsonwebtoken';
import { tokenRequired } from '../../auth/middelware';

const timerouter = express.Router();

timerouter.post('/save_area_sender', tokenRequired, saveAreaSender);

timerouter.post('/gettime', GetTime);

export default timerouter;