import React, { useEffect, useState } from 'react';
import styles from './App.module.css';
import Dashboard from './pages/dashboard/Dashboard';
import Login from './pages/login/Login';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Tabs from './pages/login/Tabs';
import Test from './pages/test/Test';
import Welcome from './pages/dashboard/Welcome';
import SignUp from './pages/login/SignUp';
import AuthPage from './pages/login/AuthPage';
import Sync from './pages/Sync';
import Debug from './pages/debug/Debug';
import Blank from './pages/test/Blank';
import Successlogin from './pages/login/Succeslogin';
import NewArea from './pages/dashboard/NewArea';
import Coincap_new from './pages/dashboard/new/Coincap';
import Football_new from './pages/dashboard/new/Football';
import Github_new from './pages/dashboard/new/Github';
import Gmail_new from './pages/dashboard/new/Gmail';
import News_new from './pages/dashboard/new/News';
import Quotes_new from './pages/dashboard/new/Quotes';
import Shopify_new from './pages/dashboard/new/Shopify';
import Slack_new from './pages/dashboard/new/Slack';
import Spotify_new from './pages/dashboard/new/Spotify';
import Telegram_new from './pages/dashboard/new/Telegram';
import Time_new from './pages/dashboard/new/Time';
import Weather_new from './pages/dashboard/new/Weather';
import Discord_new from './pages/dashboard/new/Discord';
import NewCoincapLogin from './pages/dashboard/newlogin/NewCoincapLogin';
import NewDiscordLogin from './pages/dashboard/newlogin/NewDiscordLogin';
import NewFootballLogin from './pages/dashboard/newlogin/NewFootballLogin';
import NewGithubLogin from './pages/dashboard/newlogin/NewGithubLogin';
import NewGmailLogin from './pages/dashboard/newlogin/NewGmailLogin';
import NewNewsLogin from './pages/dashboard/newlogin/NewNewsLogin';
import NewQuotesLogin from './pages/dashboard/newlogin/NewQuotesLogin';
import NewShopifyLogin from './pages/dashboard/newlogin/NewShopifyLogin';
import NewSpotifyLogin from './pages/dashboard/newlogin/NewSpotifyLogin';
import NewTelegramLogin from './pages/dashboard/newlogin/NewTelegramLogin';
import NewTimeLogin from './pages/dashboard/newlogin/NewTimeLogin';
import NewWeatherLogin from './pages/dashboard/newlogin/NewWeatherLogin';
import NewSlackLogin from './pages/dashboard/newlogin/NewSlackLogin';
import GoogleMap from './pages/dashboard/new/GoogleMap';

import NotFound from './pages/404/NotFound';

function App() {
    useEffect(() => {
        if (localStorage.getItem("SERVER_ENV_URL") === null) {
            localStorage.setItem("SERVER_ENV_URL", "https://88.166.16.161:18001");
        }
    }, []);

    return (
        <Routes>
            <Route path="/areas" element={<Welcome />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<SignUp />} />
            <Route path="/sync" element={<Sync />} />
            <Route path="/generic" element={<Dashboard />} />
            <Route path="/" element={<AuthPage />} />
            <Route path="/debug" element={<Debug/>} />
            <Route path="/blank" element={<Blank/>} />
            <Route path="/succes" element={<Successlogin/>} />
            <Route path="/newarea" element={<NewArea/>} />
            <Route path="/newarea/coincap" element={<Coincap_new/>} />
            <Route path="/newarea/discord" element={<Discord_new/>} />
            <Route path="/newarea/football" element={<Football_new/>} />
            <Route path="/newarea/github" element={<Github_new/>} />
            <Route path="/newarea/gmail" element={<Gmail_new/>} />
            <Route path="/newarea/news" element={<News_new/>} />
            <Route path="/newarea/quotes" element={<Quotes_new/>} />
            <Route path="/newarea/shopify" element={<Shopify_new/>} />
            <Route path="/newarea/slack" element={<Slack_new/>} />
            <Route path="/newarea/spotify" element={<Spotify_new/>} />
            <Route path="/newarea/telegram" element={<Telegram_new/>} />
            <Route path="/newarea/time" element={<Time_new/>} />
            <Route path="/newarea/weather" element={<Weather_new/>} />
            <Route path="/newarea/coincap/newcoincap" element={<NewCoincapLogin/>} />
            <Route path="/newarea/discord/newdiscord" element={<NewDiscordLogin/>} />
            <Route path="/newarea/football/newfootball" element={<NewFootballLogin/>} />
            <Route path="/newarea/github/newgithub" element={<NewGithubLogin/>} />
            <Route path="/newarea/gmail/newgmail" element={<NewGmailLogin/>} />
            <Route path="/newarea/news/newnews" element={<NewNewsLogin/>} />
            <Route path="/newarea/quotes/newquotes" element={<NewQuotesLogin/>} />
            <Route path="/newarea/shopify/newshopify" element={<NewShopifyLogin/>} />
            <Route path="/newarea/spotify/newspotify" element={<NewSpotifyLogin/>} />
            <Route path="/newarea/telegram/newtelegram" element={<NewTelegramLogin/>} />
            <Route path="/newarea/time/newtime" element={<NewTimeLogin/>} />
            <Route path="/newarea/weather/newweather" element={<NewWeatherLogin/>} />
            <Route path="/newarea/slack/newslack" element={<NewSlackLogin/>} />
            <Route path="/newarea/googlemap" element={<GoogleMap/>} />
            <Route path="*" element={<NotFound />} />
        </Routes>
    );
}

export default App;
