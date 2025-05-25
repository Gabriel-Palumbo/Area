import { useState } from 'react';

const clientID = process.env.REACT_APP_GOOGLE_CLIENT_ID!;
const clientSecret = process.env.REACT_APP_GOOGLE_CLIENT_SECRET!;
const redirectURI = process.env.REACT_APP_GOOGLE_REDIRECT_URI!;
const scope = process.env.REACT_APP_GOOGLE_SCOPE!;

// Générer l'URL d'authentification Google
export function getGoogleAuthURL(): string {
  const rootUrl = "https://accounts.google.com/o/oauth2/v2/auth";
  const options = {
    redirect_uri: redirectURI,
    client_id: clientID,
    access_type: "offline",
    response_type: "code",
    prompt: "consent",
    scope,
  };
  const queryString = new URLSearchParams(options).toString();
  return `${rootUrl}?${queryString}`;
}

// Obtenir le token d'accès
async function getAccessToken(code: string): Promise<string> {
  const tokenURL = "https://oauth2.googleapis.com/token";
  const body = new URLSearchParams({
    code,
    client_id: clientID,
    client_secret: clientSecret,
    redirect_uri: redirectURI,
    grant_type: "authorization_code",
  });

  const response = await fetch(tokenURL, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: body.toString(),
  });

  const data = await response.json();
  return data.access_token;
}

// Récupérer les informations de l'utilisateur
async function getUserInfo(accessToken: string): Promise<any> {
  const userInfoURL = "https://www.googleapis.com/oauth2/v2/userinfo";

  const response = await fetch(userInfoURL, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  return await response.json();
}

export function useGoogleAuth() {
  const [userInfo, setUserInfo] = useState<any>(null); // État pour stocker les informations de l'utilisateur

  const handleLogin = () => {
    const authURL = getGoogleAuthURL();
    const newWindow = window.open(authURL, '_blank', 'width=500,height=600');

    const interval = setInterval(() => {
      try {
        if (newWindow && newWindow.location) {
          const url = new URL(newWindow.location.toString());
          const code = url.searchParams.get("code");
          if (code) {
            clearInterval(interval);
            newWindow.close();

            getAccessToken(code).then(async (token) => {
              const user = await getUserInfo(token);
              setUserInfo(user);
              console.log(JSON.stringify(user, null, 2)); // Afficher les informations dans la console
            });
          }
        }
      } catch (err) {

      }
    }, 1000);
  };

  return { handleLogin, userInfo }; // Retourne la fonction handleLogin et les informations de l'utilisateur
}
