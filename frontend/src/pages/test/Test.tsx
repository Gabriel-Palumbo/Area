import React, {useState, useEffect} from "react";

const Test = () => {

    const [email, setEmail] = useState("rrr@gmail.com");
    const [password, setPassword] = useState("abcd123");
    const [serverUrl, setServerUrl] = useState<string | null>(null);
    useEffect(() => {
        if (localStorage.getItem('SERVER_ENV_URL') !== null) {
            setServerUrl(localStorage.getItem('SERVER_ENV_URL'));
        }
      }, []);

    const handleLogin = async () => {
        try {
            const response = await fetch(`${serverUrl}/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email,
                    password,
                }),
            });
            const data = await response.json();
            if (response.ok) {
                console.log('Login successful:', data);
                localStorage.setItem('token', data.token);
            } else {
                console.log('Login failed:', data);
            }
        } catch (error) {
            console.error('Error during login:', error);
        }
    };

    const handleStoreToken = async () => {
        const githubToken = ""; // Replace with actual GitHub token
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
                console.log('Token stored successfully:', data);
            } else {
                console.log('Failed to store token:', data);
            }
        } catch (error) {
            console.error('Error storing GitHub token:', error);
        }
    };



    const [repoFullName, setRepoFullName] = useState("");

    const handleRepo = async () => {
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
                setRepoFullName(data.repositories[0]);
            } else {
                console.log('Failed to fetch repos:', data);
            }
        } catch (error) {
            console.error('Error fetching repos:', error);
        }
    };

    const handleWebhook = async () => {
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

    return (
        <div>
            <h1>Fetch Demo page</h1>
            <br />
            <p>Pages with UI are at Routes '/login' and '/dashboard'</p>
            <br />
            <br />
            <h5>Login Page</h5>
            <br />
            <input type="email" placeholder="email" value={email} />
            <input type="password" placeholder="password" value={password} />
            <button onClick={handleLogin}>Login</button>
            <br />
            <button onClick={handleStoreToken}>store token</button>
            <br />
            <button onClick={handleRepo}>Repo</button>
            <br />
            <button onClick={handleWebhook}>Webhook</button>
        </div>
    )
}

export default Test;
