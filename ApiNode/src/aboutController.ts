import { Request, Response } from 'express';
import fs from 'fs';
import path from 'path';

export const getAboutData = (clientIp: string) => {
    const filePath = path.join(__dirname, '../about.json');
    const jsonData = fs.readFileSync(filePath, 'utf-8');
    const aboutData = JSON.parse(jsonData);

    const currentTime = Math.floor(Date.now() / 1000);

    const responseData = {
        client: {
            host: clientIp
        },
        server: {
            current_time: currentTime,
            services: aboutData.services
        }
    };

    return responseData;
};


export const handleAboutRequest = (req: Request, res: Response) => {
    try {
        const clientIp = (req.ip && req.ip.includes(':') ? req.ip.split(':').pop() : req.ip) || 'unknown';

        const aboutData = getAboutData(clientIp as string);

        return res.status(200).json(aboutData);
    } catch (error) {
        console.error('Error fetching about.json:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};