import React, { useEffect } from 'react';
import styles from "./SignUp.module.css";
import { useNavigate } from 'react-router-dom';
import GoogleIcon from '../../images/gmail.png';
import { useState } from 'react';

const SignUp = () => {
    const [name, setName] = useState<string>('');
    const [email, setEmail] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [password2, setPassword2] = useState<string>('');
    const [token, setToken] = React.useState<string>('null');
    const [serverUrl, setServerUrl] = useState<string | null>(null);

    useEffect(() => {
        if (localStorage.getItem("SERVER_ENV_URL") !== null) {
            setServerUrl(localStorage.getItem("SERVER_ENV_URL"));
        }
    }, []);


    const inputNameEvenement = (e: React.ChangeEvent<HTMLInputElement>) => {
        setName(e.target.value);
    };

    const inputEmailEvent = (e: React.ChangeEvent<HTMLInputElement>) => {
        setEmail(e.target.value);
    };

    const inputPasswordEvent = (e: React.ChangeEvent<HTMLInputElement>) => {
        setPassword(e.target.value);
    };

    const inputVerifyPasswordEvent = (e: React.ChangeEvent<HTMLInputElement>) => {
        setPassword2(e.target.value);
    };

    const handleLogingoogle = () => {
        window.location.href = `https://localhost:8080/google/auth`;
    };

    const register = async () => {
        try {
            const response = await fetch(`${serverUrl}/register`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    name: name,
                    email: email,
                    password: password,
                    collectionName: "customers"
                })
            });
            const data = await response.json();
            if (response.ok) {
                setToken(data.token);
                localStorage.setItem('token', data.token);
                console.log('register successful:', data);
            } else {
                console.error('register failed:', data);
            }
        } catch (error) {
            console.error('Error during login:', error);
        }
    };



    return (
        <div className={styles.login}>
            <h2 className={styles.backToHome}>Retour à l'accueil</h2>
            <form className={`${styles.form} ${styles.visible}`} onSubmit={(e) => { e.preventDefault(); register(); }}>
                <h1 className={styles.title}>S'inscrire</h1>
                
                <input
                    type="text"
                    className={styles.input}
                    placeholder="Nom"
                    value={name}
                    onChange={inputNameEvenement}
                />
                
                <input
                    type="email"
                    className={styles.input}
                    placeholder="Email" 
                    value={email}
                    onChange={inputEmailEvent}
                />
                
                <input
                    type="password"
                    className={styles.input}
                    placeholder="Mot de passe"
                    value={password}
                    onChange={inputPasswordEvent}
                />

                <input
                    type="password"
                    className={styles.input}
                    placeholder="Confirmer le mot de passe"
                    value={password2}
                    onChange={inputVerifyPasswordEvent}
                />

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

                <button type="submit" className={styles.button}>
                    S'inscrire
                </button>
            </form>
        </div>
    );

}

export default SignUp;