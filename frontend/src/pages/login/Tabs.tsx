// src/components/Tabs.tsx
import React, { useState } from 'react';
import loginCss from './Login.module.css';
import SignUp from './SignUp';
import Login from './Login';
import { ReactComponent as BackgroundSvg } from './background.svg';
import './Login.module.css'

const Tabs: React.FC = () => {
    const [activeTab, setActiveTab] = useState<'login' | 'signup'>('login');

    const handleTabChange = (tab: 'login' | 'signup') => {
        setActiveTab(tab);
    };

    const handleGoogleSuccess = (credential: string) => {
        console.log('Google login successful:', credential);
    };

    const handleGoogleFailure = (error: any) => {
        console.log('Google login failed:', error);
    };

    return (
        <div className={loginCss.tabsContainer}>
            <div className={loginCss.H1}> AREA</div>
            <BackgroundSvg className={loginCss.backgroundSvg} />

            <div className={loginCss.tabsHeader}>
                <div className={loginCss.buttoncontainer}>
                    <button
                        className={`${loginCss.tabButton} ${activeTab === 'login' ? loginCss.activeTab : ''}`}
                        onClick={() => handleTabChange('login')}
                    >
                        Se connecter
                    </button>
                    <button
                        className={`${loginCss.tabButton} ${activeTab === 'signup' ? loginCss.activeTab : ''}`}
                        onClick={() => handleTabChange('signup')}
                    >
                        Créer son compte
                    </button>
                </div>
            </div>

            <div className={loginCss.tabContent}>
                {activeTab === 'login' && <Login />}
                {activeTab === 'signup' && <SignUp />}
                <div className={loginCss.googleAuthContainer}>
                </div>
            </div>
        </div>
    );
};

export default Tabs;
