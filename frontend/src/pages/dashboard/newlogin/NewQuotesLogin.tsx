import React, { useState, useEffect } from 'react';
import styles from './newlogin.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';


const NewQuotesLogin = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    const [apiKey, setApiKey] = useState<string>("");
    const [apiSecret, setApiSecret] = useState<string>("");

    useEffect(() => {
        const quotesModule = Object.values(modules).find(module => module.name === 'quotes');
        if (quotesModule) {
            setIcon(quotesModule.url);
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

    const handleActivate = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/quotes/save_sender`, {
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
                window.alert("Quotes service activated successfully");
                navigate('/newarea/quotes');
            } else {
                window.alert("Failed to activate quotes service");
            }
        } catch (error) {
            console.error('Error activating quotes service:', error);
        }
    };

    useEffect(() => {
        fetchConnectedModules();
    }, [serverUrl]);

    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea/quotes')}/>
                <h1>quotes</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>quotes</h2>
            </div>
            <input type="text" placeholder="API Key" className={styles.input} onChange={handleApiKeyChange} value={apiKey} />
            <input type="text" placeholder="API Secret" className={styles.input} onChange={handleApiSecretChange} value={apiSecret}/>
            <button 
                className={styles.button} 
                onClick={handleActivate}
                disabled={!apiKey || !apiSecret}
            >
                Activer quotes
            </button>
        </div>
    );
};

export default NewQuotesLogin;