import { Response } from 'express';
import { db } from '../../init_db';
import { doc, setDoc, getDoc } from 'firebase/firestore';
import { AuthenticatedRequest } from '../../auth/middelware';
import https from 'https';

const REVOLUT_API_BASE_URL = 'https://sandbox-b2b.revolut.com/api/1.0';

export async function storeRevolutToken(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const { revolutToken } = req.body;

        if (!revolutToken) {
            return res.status(400).json({ success: false, error: 'Revolut token is required' });
        }

        const userRef = doc(db, 'users', req.user!.uid);
        await setDoc(userRef, { revolutToken }, { merge: true });

        return res.status(200).json({ success: true, message: 'Revolut token stored successfully' });
    } catch (error) {
        console.error('Error processing Revolut token:', error);
        return res.status(500).json({ success: false, error: 'Internal server error' });
    }
}

function makeHttpRequest(url: string, options: https.RequestOptions): Promise<any> {
    return new Promise((resolve, reject) => {
        const req = https.request(url, options, (res) => {
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });
            res.on('end', () => {
                resolve(JSON.parse(data));
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        if (options.method === 'POST' && options.body) {
            req.write(options.body);
        }

        req.end();
    });
}

export async function getRevolutAccounts(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userRef = doc(db, 'users', req.user!.uid);
        const userDoc = await getDoc(userRef);
        const revolutToken = userDoc.data()?.revolutToken;

        if (!revolutToken) {
            return res.status(400).json({ success: false, error: 'Revolut token not found' });
        }

        const options: https.RequestOptions = {
            method: 'GET',
            headers: { 'Authorization': `Bearer ${revolutToken}` }
        };

        const data = await makeHttpRequest(`${REVOLUT_API_BASE_URL}/accounts`, options);
        return res.status(200).json({ success: true, accounts: data });
    } catch (error) {
        console.error('Error fetching Revolut accounts:', error);
        return res.status(500).json({ success: false, error: 'Internal server error' });
    }
}

export async function getRevolutTransactions(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userRef = doc(db, 'users', req.user!.uid);
        const userDoc = await getDoc(userRef);
        const revolutToken = userDoc.data()?.revolutToken;

        if (!revolutToken) {
            return res.status(400).json({ success: false, error: 'Revolut token not found' });
        }

        const options: https.RequestOptions = {
            method: 'GET',
            headers: { 'Authorization': `Bearer ${revolutToken}` }
        };

        const data = await makeHttpRequest(`${REVOLUT_API_BASE_URL}/transactions`, options);
        return res.status(200).json({ success: true, transactions: data });
    } catch (error) {
        console.error('Error fetching Revolut transactions:', error);
        return res.status(500).json({ success: false, error: 'Internal server error' });
    }
}

export async function createRevolutPayment(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const { amount, currency, accountId, receiverAccountId } = req.body;
        const userRef = doc(db, 'users', req.user!.uid);
        const userDoc = await getDoc(userRef);
        const revolutToken = userDoc.data()?.revolutToken;

        if (!revolutToken) {
            return res.status(400).json({ success: false, error: 'Revolut token not found' });
        }

        const paymentData = JSON.stringify({
            amount,
            currency,
            account_id: accountId,
            receiver: { account_id: receiverAccountId }
        });

        const options: https.RequestOptions = {
            method: 'POST',
            headers: { 
                'Authorization': `Bearer ${revolutToken}`,
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(paymentData)
            },
            body: paymentData
        };

        const data = await makeHttpRequest(`${REVOLUT_API_BASE_URL}/pay`, options);
        return res.status(200).json({ success: true, payment: data });
    } catch (error) {
        console.error('Error creating Revolut payment:', error);
        return res.status(500).json({ success: false, error: 'Internal server error' });
    }
}



