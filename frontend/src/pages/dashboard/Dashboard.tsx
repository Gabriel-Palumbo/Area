import React, { useState, useEffect } from "react";
import styles from "./Dashboard.module.css";
import Header from "../../components/header/Header";

interface DashboardModuleProps {
    title: string;
    onStoreToken: (token: string) => void;
    onFetchRepos?: () => void;
    onCreateWebhook?: (repo: string) => void;
    onFetchChannels?: () => void;
    onCreateBot?: (channel: string) => void;
    isConnected: boolean;
    repos?: string[];
    channels?: string[];
}

const GithubModule = ({ title, onStoreToken, onFetchRepos, onCreateWebhook, isConnected, repos }: DashboardModuleProps) => {
    const [githubToken, setGithubToken] = useState("");
    const [selectedRepo, setSelectedRepo] = useState("");

    return (
        <div className={styles.module}>
            <div className={styles.moduleTextList}>
                <h2>{title}</h2>
                {!isConnected ? (
                    <>
                        <input
                            type="text"
                            placeholder="Enter GitHub Token"
                            value={githubToken}
                            onChange={(e) => setGithubToken(e.target.value)}
                            className={styles.input}
                        />
                        <button onClick={() => onStoreToken(githubToken)} className={styles.button}>Connect GitHub</button>
                    </>
                ) : (
                    <>
                        <button onClick={onFetchRepos} className={styles.button}>Fetch Repositories</button>
                        {repos && repos.length > 0 && (
                            <>
                                <select 
                                    value={selectedRepo} 
                                    onChange={(e) => setSelectedRepo(e.target.value)}
                                    className={styles.select}
                                >
                                    <option value="">Select a repository</option>
                                    {repos.map((repo, index) => (
                                        <option key={index} value={repo}>{repo}</option>
                                    ))}
                                </select>
                                <button 
                                    onClick={() => onCreateWebhook && onCreateWebhook(selectedRepo)} 
                                    disabled={!selectedRepo}
                                    className={`${styles.button} ${!selectedRepo ? styles.buttonDisabled : ''}`}
                                >
                                    Create Webhook
                                </button>
                            </>
                        )}
                    </>
                )}
            </div>
        </div>
    );
}

const DiscordModule = ({ title, onStoreToken, onFetchChannels, onCreateBot, isConnected, channels }: DashboardModuleProps) => {
    const [discordToken, setDiscordToken] = useState("");
    const [selectedChannel, setSelectedChannel] = useState("");

    return (
        <div className={styles.module}>
            <div className={styles.moduleTextList}>
                <h2>{title}</h2>
                {!isConnected ? (
                    <>
                        <input
                            type="text"
                            placeholder="Enter Discord Token"
                            value={discordToken}
                            onChange={(e) => setDiscordToken(e.target.value)}
                            className={styles.input}
                        />
                        <button onClick={() => onStoreToken(discordToken)} className={styles.button}>Connect Discord</button>
                    </>
                ) : (
                    <>
                        <button onClick={onFetchChannels} className={styles.button}>Fetch Channels</button>
                        {channels && channels.length > 0 && (
                            <>
                                <select 
                                    value={selectedChannel} 
                                    onChange={(e) => setSelectedChannel(e.target.value)}
                                    className={styles.select}
                                >
                                    <option value="">Select a channel</option>
                                    {channels.map((channel, index) => (
                                        <option key={index} value={channel}>{channel}</option>
                                    ))}
                                </select>
                                <button 
                                    onClick={() => onCreateBot && onCreateBot(selectedChannel)} 
                                    disabled={!selectedChannel}
                                    className={`${styles.button} ${!selectedChannel ? styles.buttonDisabled : ''}`}
                                >
                                    Create Bot
                                </button>
                            </>
                        )}
                    </>
                )}
            </div>
        </div>
    );
}

const Dashboard = () => {
    const modules = ['GitHub', 'Discord'];
    const [moduleList] = useState(modules);
    const [repos, setRepos] = useState<string[]>([]);
    const [channels, setChannels] = useState<string[]>([]);
    const [isGithubConnected, setIsGithubConnected] = useState(false);
    const [isDiscordConnected, setIsDiscordConnected] = useState(false);
    const [serverUrl, setServerUrl] = useState<string | null>(null);

    useEffect(() => {
        if (localStorage.getItem('SERVER_ENV_URL') !== null) {
            setServerUrl(localStorage.getItem('SERVER_ENV_URL'));
        }
      }, []);

    const handleStoreGithubToken = async (githubToken: string) => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/github/store-token`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${bearerToken}`,
                },
                body: JSON.stringify({
                    githubToken,
                }),
            });

            const data = await response.json();
            if (response.ok) {
                console.log('GitHub token stored successfully:', data);
                setIsGithubConnected(true);
            } else {
                console.log('Failed to store GitHub token:', data);
            }
        } catch (error) {
            console.error('Error storing GitHub token:', error);
        }
    };

    const handleStoreDiscordToken = async (discordToken: string) => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/discord/store-token`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${bearerToken}`,
                },
                body: JSON.stringify({
                    discordToken,
                }),
            });

            const data = await response.json();
            if (response.ok) {
                console.log('Discord token stored successfully:', data);
                setIsDiscordConnected(true);
            } else {
                console.log('Failed to store Discord token:', data);
            }
        } catch (error) {
            console.error('Error storing Discord token:', error);
        }
    };

    const handleFetchRepos = async () => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/github/repos`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${bearerToken}`,
                },
            });

            const data = await response.json();
            if (response.ok) {
                console.log('Fetched repos:', data);
                setRepos(data.repositories);
            } else {
                console.log('Failed to fetch repos:', data);
            }
        } catch (error) {
            console.error('Error fetching repos:', error);
        }
    };

    const handleCreateWebhook = async (repoFullName: string) => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/github/create-webhook`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${bearerToken}`,
                },
                body: JSON.stringify({
                    repoFullName,
                }),
            });

            const data = await response.json();
            if (response.ok) {
                console.log('Webhook created successfully:', data);
            } else {
                console.log('Failed to create webhook:', data);
            }
        } catch (error) {
            console.error('Error creating webhook:', error);
        }
    }

    const handleFetchChannels = async () => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/discord/channels`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${bearerToken}`,
                },
            });

            const data = await response.json();
            if (response.ok) {
                console.log('Fetched channels:', data);
                setChannels(data.channels);
            } else {
                console.log('Failed to fetch channels:', data);
            }
        } catch (error) {
            console.error('Error fetching channels:', error);
        }
    };

    const handleCreateBot = async (channelId: string) => {
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/discord/create-bot`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${bearerToken}`,
                },
                body: JSON.stringify({
                    channelId,
                }),
            });

            const data = await response.json();
            if (response.ok) {
                console.log('Bot created successfully:', data);
            } else {
                console.log('Failed to create bot:', data);
            }
        } catch (error) {
            console.error('Error creating bot:', error);
        }
    }
    const [isSpotifyConnected, setIsSpotifyConnected] = useState(false);
    const handleStoreSpotifyToken = async (spotifyToken: string) => {
        spotifyToken = "db567721e1014ec39c30853970362a89";
        const bearerToken = localStorage.getItem('token');
        try {
            const response = await fetch(`${serverUrl}/services/spotify/store-spotify-token`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${bearerToken}`,
                },
                body: JSON.stringify({
                    spotifyToken,
                }),
            });
            if (response.ok) {
                const data = await response.json();
                console.log('Spotify token stored successfully:', data);
                setIsSpotifyConnected(true);
            } else {
                const errorData = await response.text();
                console.log('Failed to store Spotify token:', response.status, errorData);
            }
        } catch (error) {
            console.error('Error storing Spotify token:', error);
        }
    }

    return (
        <div className={styles.dashboard}>
        <Header />
        <div className={styles.moduleList}>
            <GithubModule 
                title="GitHub"
                onStoreToken={handleStoreGithubToken}
                onFetchRepos={handleFetchRepos}
                onCreateWebhook={handleCreateWebhook}
                isConnected={isGithubConnected}
                repos={repos}
            />
            <DiscordModule 
                title="Discord"
                onStoreToken={handleStoreDiscordToken}
                onFetchChannels={handleFetchChannels}
                onCreateBot={handleCreateBot}
                isConnected={isDiscordConnected}
                channels={channels}
            />
        </div>
        <button onClick={() => handleStoreSpotifyToken('db567721e1014ec39c30853970362a89')}>Connect Spotify</button>
        </div>
    );
};

export default Dashboard;
