import { Request, Response } from 'express';
import axios from 'axios';
import { timemodel } from './models/timemodels';
import { Timestamp } from 'firebase/firestore';

export async function GetTime(req: Request, res: Response): Promise<Response> {
    const { area } = req.body;

    try {
        const response = await axios.get(`http://worldtimeapi.org/api/timezone/${area}`);
        
        if (!response.data.datetime || !response.data.timezone) {
            return res.status(500).json({
                message: 'Données manquantes dans la réponse de l\'API',
            });
        }

        const { datetime, timezone } = response.data;

        const timeData: timemodel = {
            time: Timestamp.fromDate(new Date(datetime)),
            timezone: timezone,
            last_updated: Timestamp.now()
        };

        return res.status(200).json(timeData);

    } catch (error) {
        console.error("Erreur lors de la récupération de l'heure :", error);

        return res.status(500).json({
            message: 'Erreur lors de la récupération de l\'heure',
        });
    }
}
