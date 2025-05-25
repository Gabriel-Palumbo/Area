import express from 'express';
import {calculateTravelTime} from './Controller';
import { tokenRequired } from '../../auth/middelware';
import { saveTravelDetails } from './save';

const mapsrouter = express.Router();

mapsrouter.post('/save_sender', tokenRequired, saveTravelDetails);
mapsrouter.post('/traveltime', tokenRequired, calculateTravelTime);

export default mapsrouter;