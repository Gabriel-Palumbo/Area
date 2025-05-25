import React, { useState, useEffect } from 'react';
import styles from './newlogin.module.css';
import arrowLeft from '../../../images/back_arrow.png';
import { useNavigate } from 'react-router-dom';

const NewGithubLogin = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    const [modules, setModules] = useState<any[]>([]);
    const [icon, setIcon] = useState<string | null>("");
    const [githubToken, setGithubToken] = useState<string>("");
    const [selectedRepo, setSelectedRepo] = useState<string>("");
    const [repos, setRepos] = useState<string[]>([]);

    useEffect(() => {
        const githubModule = Object.values(modules).find(module => module.name === 'github');
        if (githubModule) {
            setIcon(githubModule.url);
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

    const handleTokenChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setGithubToken(e.target.value);
    };

    const handleRepoChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setSelectedRepo(e.target.value);
    };

    const storeGithubToken = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/github/store-token`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    github_token: githubToken
                })
            });

            if (response.ok) {
                fetchGithubRepos();
            } else {
                window.alert("Failed to store GitHub token");
            }
        } catch (error) {
            console.error('Error storing GitHub token:', error);
        }
    };

    const fetchGithubRepos = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/github/repos`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                setRepos(data);
            }
        } catch (error) {
            console.error('Error fetching GitHub repos:', error);
        }
    };

    const createWebhook = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await fetch(`${serverUrl}/services/github/create-webhook`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    repo: selectedRepo
                })
            });

            if (response.ok) {
                window.alert("GitHub webhook created successfully");
                navigate('/newarea/github');
            } else {
                window.alert("Failed to create GitHub webhook");
            }
        } catch (error) {
            console.error('Error creating GitHub webhook:', error);
        }
    };

    useEffect(() => {
        fetchConnectedModules();
    }, [serverUrl]);

    return (
        <div className={styles.newArea}>
            <div className={styles.header}>
                <img src={arrowLeft} alt="Retour" className={styles.backArrow} onClick={() => navigate('/newarea/github')}/>
                <h1>github</h1>
            </div>
            <div className={styles.content}>
                <img src={icon || ""} alt={icon || ""} className={styles.module_icon} />
                <h2>github</h2>
            </div>
            <input 
                type="text" 
                placeholder="GitHub Token" 
                className={styles.input} 
                onChange={handleTokenChange} 
                value={githubToken}
            />
            <button 
                className={styles.button} 
                onClick={storeGithubToken}
                disabled={!githubToken}
            >
                Connect GitHub
            </button>
            {repos.length > 0 && (
                <>
                    <select 
                        className={styles.input} 
                        value={selectedRepo} 
                        onChange={handleRepoChange}
                    >
                        <option value="">Select a repository</option>
                        {repos.map((repo) => (
                            <option key={repo} value={repo}>{repo}</option>
                        ))}
                    </select>
                    <button 
                        className={styles.button} 
                        onClick={createWebhook}
                        disabled={!selectedRepo}
                    >
                        Create Webhook
                    </button>
                </>
            )}
        </div>
    );
};

export default NewGithubLogin;