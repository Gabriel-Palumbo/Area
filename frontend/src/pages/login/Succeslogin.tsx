import React, { useState, useEffect } from 'react';
import styles from './Login.module.css';
import GoogleIcon from '../../images/gmail.png';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { time } from 'console';

const Successlogin = () => {
    const navigate = useNavigate();
    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        const token = params.get('token');

        if (token) {
            localStorage.setItem('token', token);
            console.log('Token received and saved:', token);
            navigate('/areas');
        } else {
            console.log('No token found in URL');
        }
    }, [navigate]);

    return (
        <div> 
            <h1>
                connection en cours...
            </h1>
        </div>
    )
}

export default Successlogin
