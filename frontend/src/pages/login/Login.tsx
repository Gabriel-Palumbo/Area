import React, { useState, useEffect } from 'react';
import styles from './Login.module.css';
import GoogleIcon from '../../images/gmail.png';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const Login: React.FC = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        try {
            const response = await fetch(`${serverUrl}/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email,
                    password,
                }),
            });
            const data = await response.json();
            if (response.ok) {
                console.log('Login successful:', data);
                navigate('/areas');
                localStorage.setItem('token', data.token);
            } else {
                console.log('Login failed:', data);
            }
        } catch (error) {
            console.error('Error during login:', error);
        }
    };

    const handleLogingoogle = () => {
        window.location.href = `https://localhost:8080/google/auth`;
    };


    useEffect(() => {
        if (localStorage.getItem('SERVER_ENV_URL') !== null) {
            setServerUrl(localStorage.getItem('SERVER_ENV_URL'));
        }
    }, []);

    useEffect(() => {
        // Récupérer le token de l'URL
        const params = new URLSearchParams(window.location.search);
        const token = params.get('token');

        if (token) {
            localStorage.setItem('token', token);
            console.log('Token received and saved:', token);
            navigate('/area');
        } else {
            console.log('No token found in URL');
        }
    }, [navigate]);

    return (
        <div className={styles.login}>
            <form className={`${styles.form} ${styles.visible}`} onSubmit={handleSubmit}>
                <h1 className={styles.title}>Connectez-vous</h1>
                <input
                    type="email"
                    className={styles.input}
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                />
                <input
                    type="password"
                    className={styles.input}
                    placeholder="Mot de passe"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                />
                <button type="submit" className={styles.button}>
                    Se connecter
                </button>
                <div className={styles.googleAuthContainer}>
                    <button
                        type="button"
                        id={styles.googleSignInDiv}
                        onClick={handleLogingoogle}
                    >
                        <img src={GoogleIcon} alt="Google" className={styles['google-logo']} />
                        <span className={styles['google-btn-text']}>Se connecter avec Google</span>
                    </button>
                </div>
                <a href="/reset-password" className={styles.resetPassword}>
                    Mot de passe oublié?
                </a>
            </form>
        </div>
    );
};

export default Login;
