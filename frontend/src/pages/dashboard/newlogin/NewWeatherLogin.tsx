import React, { useState, useEffect } from 'react';
import styles from './newlogin.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';

const NewWeatherLogin = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    const [selectedCity, setSelectedCity] = useState<string>("");

    const cities = [
        "Paris",
        "London",
        "New York",
        "Tokyo",
        "Berlin",
        "Madrid",
        "Rome",
        "Moscow",
        "Beijing",
        "Sydney"
    ];

    useEffect(() => {
        const weatherModule = Object.values(modules).find(module => module.name === 'weather');
        if (weatherModule) {
            setIcon(weatherModule.url);
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

    const handleCityChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        console.log(e.target.value);
        setSelectedCity(e.target.value);
    };

    const handleActivate = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/weather/save_ville_token`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    city: selectedCity
                })
            });

            if (response.ok) {
                window.alert("Weather service activated");
            } else {
                window.alert("Failed to activate weather service");
            }
        } catch (error) {
            console.error('Error activating weather service:', error);
        }
    };

    useEffect(() => {
        fetchConnectedModules();
    }, [serverUrl]);

    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea/weather')}/>
                <h1>weather</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>weather</h2>
            </div>
            <select 
                className={styles.input} 
                value={selectedCity} 
                onChange={handleCityChange}
            >
                <option value="">Select a city</option>
                {cities.map((city) => (
                    <option key={city} value={city}>{city}</option>
                ))}
            </select>
            <button 
                className={styles.button} 
                onClick={handleActivate}
                disabled={!selectedCity}
            >
                Activer weather
            </button>
        </div>
    );
};

export default NewWeatherLogin;