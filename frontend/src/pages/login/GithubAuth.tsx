import { useState } from 'react';

const clientID = "Ov23lipxfoPj3FZaZv9W";
const redirectURI = "http://localhost:3000/callback";
const scope = "read:user user:email";

export function getGitHubAuthURL(): string {
  const rootUrl = "https://github.com/login/oauth/authorize";
  const options = {
    client_id: clientID,
    redirect_uri: redirectURI,
    scope,
  };
  const queryString = new URLSearchParams(options).toString();
  return `${rootUrl}?${queryString}`;
}

async function getAccessToken(code: string): Promise<string> {
    const tokenURL = "https://github.com/login/oauth/access_token";
  
    const body = new URLSearchParams({
      client_id: clientID,
      code: code,
    });
  
    try {
      const response = await fetch(tokenURL, {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body.toString(),
      });
  
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Erreur lors de l'obtention du token : ${errorData.error || response.statusText}`);
      }
  
      const data = await response.json();
      return data.access_token;
    } catch (error) {
      console.error("Erreur dans getAccessToken :", error);
      throw error; 
    }
}


async function getUserInfoGit(accessToken: string): Promise<any> {
  const userInfoGitURL = "https://api.github.com/user";
  const response = await fetch(userInfoGitURL, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      Accept: "application/vnd.github.v3+json",
    },
  });
  if (!response.ok) {
    throw new Error(`Erreur lors de la récupération des informations utilisateur : ${response.statusText}`);
  }
  return await response.json();
}

export function useGitHubAuth() {
  const [userInfoGit, setUserInfoGit] = useState<any>(null);
  
  const handleGit = () => {
    const authURL = getGitHubAuthURL();
    const newWindow = window.open(authURL, '_blank', 'width=500,height=600');
    const interval = setInterval(() => {
      if (newWindow) {
        try {
          if (newWindow.location && newWindow.location.href.startsWith(redirectURI)) {
            const url = new URL(newWindow.location.toString());
            const code = url.searchParams.get("code");
            if (code) {
              clearInterval(interval);
              newWindow.close();
              getAccessToken(code).then(async (token) => {
                const user = await getUserInfoGit(token);
                setUserInfoGit(user);
                
                console.log("Informations de l'utilisateur GitHub :", JSON.stringify(user, null, 2));
              });
            }
          }
        } catch (err) {
          // Ignorer les erreurs de cross-origin
        }
      }
    }, 1000);
  };

  return { handleGit, userInfoGit };
}
