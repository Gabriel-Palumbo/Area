import { useState, useEffect } from 'react';
import styles from './NewArea.module.css';
import arrowLeft from '../../images/back_arrow.png';
import green_check from '../../images/green_check.png';
import red_check from '../../images/cross_check.png';
import { useNavigate } from 'react-router-dom';



const Little_module = ({name, icon, connected}: {name: string, icon: string, connected: boolean}) => {

    const navigate = useNavigate();

    const handleClick = () => {
        navigate(`/newarea/${name}`);
    };

    return (
        <div className={styles.little_module} onClick={handleClick}>
            <img src={icon} alt="Gmail" className={styles.module_icon} />
            <h2>{name}</h2>
            <img src={connected ? green_check : red_check} alt="Gmail" className={styles.module_icon_check} />
        </div>
    );
};


const NewArea = () => {

    const navigate = useNavigate();

    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);

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
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/areas')}/>
                <h1>Vos Comptes</h1>
            </div>
            <div className={styles.connected}>
                <h1>Connectés</h1>
            </div>
            <div className={styles.connected_modules}>
                {Object.entries(modules)
                    .filter(([_, module]) => module.is_connected)
                    .map(([key, module]) => (
                        <Little_module 
                            key={key}
                            name={module.name} 
                            icon={module.url}
                            connected={module.is_connected}
                        />
                    ))}
            </div>
            <div className={styles.disconnected}>
                <h1>Déconnectés</h1>
            </div>
            <div className={styles.disconnected_modules}>
                {Object.entries(modules).map(([key, module]) => (
                    <Little_module 
                        key={key}
                        name={module.name} 
                        icon={module.url}
                        connected={module.is_connected}
                    />
                ))}
            </div>
            <h1 className={styles.see_areas} onClick={() => navigate('/areas')}>Voir les areas</h1>
        </div>
    );
};

export default NewArea;
