import { ninjaModel } from "./models/ninjamodels";
import { Request, Response } from 'express';
import axios from 'axios';

export async function GetNinjaQuotes(req: Request, res: Response): Promise<Response> {
    const { category } = req.body;
    try {
        const response = await axios.get(`https://api.api-ninjas.com/v1/quotes?category=${category}`, {
            headers: { 'X-Api-Key': process.env.NINJA_APIKEY } 
        });
        
        if (!response.data || response.data.length === 0) {
            return res.status(404).json({ message: 'Aucune citation trouvée pour cette catégorie.' });
        }

        const quotes: ninjaModel[] = response.data.map((item: any) => ({
            quote: item.quote,
            author: item.author,
            category: item.category,
        }));

        return res.status(200).json(quotes);
    } catch (error) {
        console.error("Erreur lors de la récupération des citations :", error);
        return res.status(500).json({
            message: 'Erreur lors de la récupération des citations.',
        });
    }
}