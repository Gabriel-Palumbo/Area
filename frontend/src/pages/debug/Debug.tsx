import { useState, useEffect } from 'react';
import styles from './Debug.module.css';

const Debug = () => {
    const [actual, setActual] = useState(localStorage.getItem("SERVER_ENV_URL"));
    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        localStorage.setItem("SERVER_ENV_URL", e.target.value);
    };

    const handleSubmit = () => {
        setActual(localStorage.getItem("SERVER_ENV_URL"));
    };

    useEffect(() => {
        setActual(localStorage.getItem("SERVER_ENV_URL"));
    }, [localStorage.getItem("SERVER_ENV_URL")]);

    return (
        <div className={styles.debug}>
            <h1 className={styles.title}>Debug Page</h1>
            <input className={styles.input} type="text" placeholder="{SERVER ENV URL}" onChange={handleChange}/>
            <button className={styles.button} onClick={handleSubmit}>Submit</button>
            <p className={styles.p}>Actual: {actual}</p>
        </div>
    );
};

export default Debug;