import { Request, Response } from 'express';
import * as crypto from 'crypto';

const SHOPIFY_API_KEY = process.env.SHOPIFY_API_KEY;
const SHOPIFY_API_SECRET = process.env.SHOPIFY_API_SECRET;
const SHOPIFY_SCOPES = 'read_products,write_products';
const REDIRECT_URI = `${process.env.APP_URL}/shopify/callback`;

export const initiateAuth = (req: Request, res: Response) => {
    const shop = req.query.shop as string;
    if (!shop) {
        return res.status(400).send('Missing shop parameter');
    }

    const nonce = crypto.randomBytes(16).toString('hex');
    const authUrl = `https://${shop}/admin/oauth/authorize?client_id=${SHOPIFY_API_KEY}&scope=${SHOPIFY_SCOPES}&redirect_uri=${REDIRECT_URI}&state=${nonce}`;

    res.redirect(authUrl);
};

export const handleCallback = async (req: Request, res: Response) => {
    const { shop, hmac, code, state } = req.query;

    if (!shop || !hmac || !code) {
        return res.status(400).send('Required parameters missing');
    }


    const message = Object.entries(req.query as Record<string, string>)
        .filter(([key]) => key !== 'hmac')
        .map(([key, value]) => `${key}=${value}`)
        .sort()
        .join('&');

    const generatedHash = crypto
        .createHmac('sha256', SHOPIFY_API_SECRET!)
        .update(message)
        .digest('hex');

    if (generatedHash !== hmac) {
        return res.status(400).send('HMAC validation failed');
    }

    try {
        const accessToken = await exchangeCodeForToken(shop as string, code as string);
        res.send('Authentication successful');
    } catch (error) {
        console.error('Error exchanging code for access token:', error);
        res.status(500).send('Error authenticating with Shopify');
    }
};

export const handleWebhook = (req: Request, res: Response) => {
    const hmac = req.get('X-Shopify-Hmac-Sha256');
    const topic = req.get('X-Shopify-Topic');
    const shopDomain = req.get('X-Shopify-Shop-Domain');

    const rawBody = JSON.stringify(req.body);
    const calculatedHmac = crypto
        .createHmac('sha256', SHOPIFY_API_SECRET!)
        .update(rawBody)
        .digest('base64');

    if (calculatedHmac !== hmac) {
        console.error('HMAC validation failed');
        return res.status(401).send('HMAC validation failed');
    }

    console.log(`Received webhook: ${topic} for shop: ${shopDomain}`);

    switch (topic) {
        case 'products/create':
            break;
        case 'orders/create':
            break;
    }

    res.status(200).send('Webhook processed successfully');
};

async function exchangeCodeForToken(shop: string, code: string): Promise<string> {
    return Promise.resolve('dummy_access_token');
}

