import React, { useState, useEffect } from 'react';
import styles from './newlogin.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';


const NewGoogleMapLogin = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    const [apiKey, setApiKey] = useState<string>("");
    const [apiSecret, setApiSecret] = useState<string>("");

    useEffect(() => {
        const googlemapModule = Object.values(modules).find(module => module.name === 'googlemap');
        if (googlemapModule) {
            setIcon(googlemapModule.url);
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

    const handleApiKeyChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setApiKey(e.target.value);
    };

    const handleApiSecretChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setApiSecret(e.target.value);
    };

    useEffect(() => {
        fetchConnectedModules();
    }, [serverUrl]);

    const connect = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/googlemap/save_sender`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    api_key: apiKey,
                    api_secret: apiSecret
                })
            });

            if (response.ok) {
                window.alert("Google Map service activated successfully");
                navigate('/newarea/googlemap');
            } else {
                window.alert("Failed to activate Google Map service");
            }
        } catch (error) {
            console.error('Error activating Google Map service:', error);
        }
    };

    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea/googlemap')}/>
                <h1>Google Map</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>Google Map</h2>
            </div>
            <input type="text" placeholder="Google Map API Key" className={styles.input} onChange={handleApiKeyChange} value={apiKey} />
            <input type="text" placeholder="Google Map API Secret" className={styles.input} onChange={handleApiSecretChange} value={apiSecret}/>
            <button 
                className={styles.button} 
                onClick={connect}
                disabled={!apiKey || !apiSecret}
            >
                Activer Google Map
            </button>
        </div>
    );
};

export default NewGoogleMapLogin;