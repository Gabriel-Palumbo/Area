import React, { useState, useEffect } from 'react';
import styles from './new.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';

const Football_new = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    useEffect(() => {
        const footballModule = Object.values(modules).find(module => module.name === 'football');
        if (footballModule) {
            setIcon(footballModule.url);
        }
    }, [modules]);

    useEffect(() => {
        if (localStorage.getItem("SERVER_ENV_URL") !== null) {
            setServerUrl(localStorage.getItem("SERVER_ENV_URL"));
        }
    }, []);

    const fetchConnectedModules = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/list_service_simple`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            const data = await response.json();
            setModules(data);
            console.log(data);
        } catch (error) {
            console.error('Error fetching connected modules:', error);
            return [];
        }
    };

    useEffect(() => {
        fetchConnectedModules();
    }, [serverUrl]);


    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea')}/>
                <h1>football</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>football</h2>
            </div>
            <video className={styles.video} autoPlay loop muted>
                <source src="https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/football-video.mp4?alt=media&token=43b7d841-18bc-4046-963e-dbed5c8f5447" type="video/mp4" className={styles.video} />
                Your browser does not support the video tag
            </video>
            <p className={styles.description}>Get the latest football information from your area and way more !</p>
            <button className={styles.button} onClick={() => navigate('/newarea/football/newfootball')}>Activer le football</button>
        </div>
    );
};

export default Football_new;
