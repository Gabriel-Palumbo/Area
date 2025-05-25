import React, { useState, useEffect } from 'react';
import styles from './newlogin.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';


const NewDiscordLogin = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    const [apiKey, setApiKey] = useState<string>("");
    const [apiSecret, setApiSecret] = useState<string>("");
    useEffect(() => {
        const discordModule = Object.values(modules).find(module => module.name === 'discord');
        if (discordModule) {
            setIcon(discordModule.url);
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


    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea/discord')}/>
                <h1>discord</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>discord</h2>
            </div>
            <input type="text" placeholder="API Key" className={styles.input} onChange={handleApiKeyChange} value={apiKey} />
            <input type="text" placeholder="API Secret" className={styles.input} onChange={handleApiSecretChange} value={apiSecret}/>
            <button className={styles.button} onClick={() => navigate('/newarea/discord/newdiscord')}>Activer discord</button>
        </div>
    );
};

export default NewDiscordLogin;