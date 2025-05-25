import request from 'supertest';
import { initFirebase } from './init_db';
import express from 'express';
import cors from 'cors';
import { app } from './server';
import { v4 as uuidv4 } from 'uuid';

const email = `testEmail-${uuidv4()}@example.com`;
const password = 'testPassword';
const collectionName = 'customers';
var token : string | null = null;

describe('Test des routes du serveur', () => {
    it('devrait enregistrer un utilisateur existant avec un code 201', async () => {

        const response1 = await request(app)
            .post('/register')
            .send({ email, password, collectionName });

        expect(response1.status).toBe(201);
        expect(response1.body.message).toBe('User registered successfully!');
    });

    it('devrait enregistrer un utilisateur existant avec un code 201', async () => {
        const response = await request(app)
            .post('/register')
            .send({ email, password, collectionName });

        expect(response.status).toBe(400);
        expect(response.body.message).toBe('User already exists!');
    });

    it('devrait connecter un utilisateur', async () => {
        const response = await request(app)
            .post('/login')
            .send({ email, password, collectionName });

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('token');
        token = response.body.token;
    });

    it('devrait échouer si aucun token n\'est fourni pour /customers_list', async () => {
        const response = await request(app).get('/customers_list');
        expect(response.status).toBe(403);
        expect(response.body.message).toBe('Token is missing!');
    });

    it('devrait récupérer la liste des clients avec un token valide', async () => {
        const token_n = 'Bearer ' + token;
        const response = await request(app)
            .get('/customers_list')
            .set('Authorization', token_n);

        expect(response.status).toBe(200);
        expect(response.body.customers).toBeInstanceOf(Array);
    });

    it('devrait retourner des tips avec un token valide', async () => {
        const token_n = 'Bearer ' + token;
        const response = await request(app)
            .get('/tips')
            .set('Authorization', token_n);

        expect(response.status).toBe(200);
        expect(response.body.tips).toBeInstanceOf(Array);
    });
});
