import { useState } from 'react';
import styles from './Sync.module.css';
import gmailIcon from '../images/gmail.png';
import githubIcon from '../images/github.png';
import spotifyIcon from '../images/spotify.png';
import slackIcon from '../images/slack.png';
import twilioIcon from '../images/twilio.png';
import zoomIcon from '../images/zoom.png';


const Sync = () => {
    return (
        <div className={styles.sync}>
            <div className={styles.header}>
                <button className={styles.backButton}>←</button>
                <h1>Vos comptes</h1>
            </div>

            <div className={styles.accountsSection}>
                <h2>Connecté</h2>
                <div className={styles.accountsList}>
                    <div className={styles.accountItem}>
                        <img src={gmailIcon} alt="Gmail" />
                        <span>Gmail</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                    <div className={styles.accountItem}>
                        <img src={githubIcon} alt="GitHub" />
                        <span>Github</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                    <div className={styles.accountItem}>
                        <img src={spotifyIcon} alt="Spotify" />
                        <span>Spotify</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                </div>
            </div>

            <div className={styles.accountsSection}>
                <h2>Déconnecté</h2>
                <div className={styles.accountsList}>
                    <div className={styles.accountItem}>
                        <img src={slackIcon} alt="Slack" />
                        <span>Slack</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                    <div className={styles.accountItem}>
                        <img src={twilioIcon} alt="Twilio" />
                        <span>Twilio</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                    <div className={styles.accountItem}>
                        <img src={zoomIcon} alt="Zoom" />
                        <span>Zoom</span>
                        <button className={styles.statusButton}>●</button>
                    </div>
                </div>
            </div>

            <div className={styles.footer}>
                <a href="/areas" className={styles.areasLink}>
                    Voir les areas →
                </a>
            </div>
        </div>
    );
};

export default Sync;
