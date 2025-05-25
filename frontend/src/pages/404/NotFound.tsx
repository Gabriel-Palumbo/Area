import React from 'react';
import styles from './NotFound.module.css';
import { useNavigate } from 'react-router-dom';

const NotFound = () => {
    const navigate = useNavigate();

    return (
        <div className={styles.notFound}>
            <h1>404</h1>
            <h2>Page Not Found</h2>
            <p>Oops! The page you are looking for does not exist.</p>
            <button 
                className={styles.homeButton}
                onClick={() => navigate('/')}
            >
                Return Home
            </button>
        </div>
    );
};

export default NotFound;
