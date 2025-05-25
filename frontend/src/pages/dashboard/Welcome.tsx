import React, { useEffect, useState } from 'react';
import styles from './Welcome.module.css';
import gmail from '../../images/gmail.png';
import github from '../../images/github.png';
import spotify from '../../images/spotify.png';
import slack from '../../images/slack.png';
import twilio from '../../images/twilio.png';
import zoom from '../../images/zoom.png';
import discord from '../../images/discord.png';
import Header from '../../components/header/Header';
import { useNavigate } from 'react-router-dom';
interface Action {
  icon: string;
  text: string;
  time: string;
}

interface EventData {
  name: string;
  description: string;
  createdAt: string;
}

const Welcome = () => {
    const navigate = useNavigate();
    const [serverUrl, setServerUrl] = useState<string | null>(null);

  const [actions, setActions] = useState<Action[]>([
  ]);

  const icons = [
    { name: 'gmail', src: gmail },
    { name: 'github', src: github },
    { name: 'spotify', src: spotify },
    { name: 'slack', src: slack },
    { name: 'twilio', src: twilio },
    { name: 'zoom', src: zoom },
    { name: 'discord', src: discord }
  ];
  const suggestions = [
    'Nouveau email reçu',
    'Nouveau email envoyé',
    'Nouveau email programmé',
    'Nouveau commit',
    'Nouvelle branche créée',
    'Nouvel album ajouté à la bibliothèque',
    'Nouvelle musique likée'
  ];

  useEffect(() => {
      const fetchRecentEvents = async () => {
        try {
          const token = localStorage.getItem('token');
        if (!token) {
          console.error('No token found in localStorage');
          return;
        }

        const response = await fetch('https://88.166.16.161:18001/services/recent_event', {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        if (response.ok) {
          const data: EventData[] = await response.json();
          console.log('Received data:', data);
          if (data && data.length > 0) {
            const newActions = data.map((item: EventData) => ({
              icon: item.name,
              text: item.description,
              time: new Date(item.createdAt).toLocaleString()
            }));
            setActions(newActions);
          } else {
            console.log('No recent events found');
          }
        } else {
          console.error('Failed to fetch recent events');
        }
      } catch (error) {
        console.error('Error fetching recent events:', error);
      }
    };

    const interval = setInterval(fetchRecentEvents, 1000);

    return () => clearInterval(interval);
  }, []);


  useEffect(() => {
    if (localStorage.getItem('SERVER_ENV_URL') !== null) {
        setServerUrl(localStorage.getItem('SERVER_ENV_URL'));
    }
  }, []);

  return (
    <div className={styles.welcomeContainer}>
      <h1 className={styles.welcomeTitle}>Welcome to AREA</h1>
      
      <div className={styles.searchBar}>
        <input type="text" placeholder="Quelles outils ?" className={styles.searchInput} />
      </div>
      
      <div className={styles.iconContainer}>
        {icons.map((icon, index) => (
          <div key={index} className={styles.iconWrapper} onClick={() => navigate('/newarea')}>
            <img src={icon.src} alt={icon.name} className={styles.icon} />
          </div>
        ))}
      </div>
      
      <div className={styles.contentContainer}>
        <div className={styles.suggestionsColumn}>
          <h2 className={styles.columnTitle}>Suggestions</h2>
          <ul className={styles.suggestionList}>
            {suggestions.map((suggestion, index) => (
              <li key={index}>{suggestion}</li>
            ))}
          </ul>
        </div>
        
        <div className={styles.actionsColumn}>
          <h2 className={styles.columnTitle}>Dernières Actions</h2>
          <ul className={styles.actionList}>
            {actions.map((action, index) => (
              <li key={index}>
                <img src={icons.find(icon => icon.name === action.icon)?.src} alt={action.icon} className={styles.actionIcon} />
                <span className={styles.actionText}>{action.text}</span>
                <span className={styles.actionTime}>{action.time}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>
      <button className={styles.addAreaButton} onClick={() => navigate('/newarea')}>Go to new areas</button>
    </div>
  );
};

export default Welcome;
