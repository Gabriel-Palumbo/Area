import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styles from "./AuthPage.module.css";
import logo from "./image.png";

const AuthPage: React.FC = () => {
    const [animate, setAnimate] = useState(false);

    useEffect(() => {
        setAnimate(true);
    }, []);

    const navigate = useNavigate();

    const handleCreateAccount = () => {
        navigate('/register');
    }

    const handleLogin = () => {
        navigate('/login');
    }

    return (
        <div className={styles.authPage}>
            <div className={`${styles.authContainer} ${animate ? styles.animate : ''}`}>
                <img src={logo} alt="AREA logo" className={styles.logo} />
                <div className={styles.authForm}>
                    <button className={styles.authButton} onClick={handleCreateAccount}>Créer un compte {'>'} </button>
                    <button className={styles.authButton} onClick={handleLogin}>Se connecter {'>'} </button>
                </div>
            </div>
        </div>
    );
};

export default AuthPage;