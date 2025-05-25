import express from 'express';
import { tokenRequired } from '../../auth/middelware';

const gmailRouter = express.Router();


export default gmailRouter;
