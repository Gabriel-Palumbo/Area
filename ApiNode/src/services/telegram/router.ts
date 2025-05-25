import { Router } from 'express';
import { tokenRequired } from '../../auth/middelware';
import { storeTelegramId } from './connectId';

const telegramRouter = Router();

// Route pour stocker l'ID Telegram
telegramRouter.post('/store_id', tokenRequired, storeTelegramId);

// D'autres routes Telegram peuvent être ajoutées ici

export default telegramRouter;
