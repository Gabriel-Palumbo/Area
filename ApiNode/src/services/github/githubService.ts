import axios from 'axios';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDocs, getDoc } from 'firebase/firestore';

const GITHUB_API_BASE = 'https://api.github.com';

export async function getUsersWithGithubLogin(strlog : string) {
    try {
        const usersSnapshot = await getDocs(collection(db, 'users'));
        const usersWithGithubLogin: any[] = [];

        for (const userDoc of usersSnapshot.docs) {
            const githubDocRef = doc(db, 'users', userDoc.id, 'services', 'github');
            const githubDocSnapshot = await getDoc(githubDocRef);
        
            if (githubDocSnapshot.exists()) {
                const githubData = githubDocSnapshot.data();
        
                if (githubData.userinfo && githubData.userinfo.login == strlog) {
                    const login = githubData.userinfo.login;
        
                    usersWithGithubLogin.push({
                        userId: userDoc.id,
                        githubLogin: login,
                    });
        
                    if (githubData.repositories) {
                        console.log(githubData.repositories);
                    }
                }
            }
        }

        return usersWithGithubLogin;
    } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs:", error);
        throw error;
    }
}

export async function getGitHubUserByToken(token: string) {
    try {
        const response = await axios.get(`${GITHUB_API_BASE}/user`, {
            headers: { Authorization: `token ${token}` }
        });
        return response.data;
    } catch (error) {
        console.error('Erreur lors de la récupération des infos utilisateur GitHub:', error);
        return null;
    }
}

export async function getAllRepositories(token: string) {
    try {
        const repos = [];
        let page = 1;
        let hasNextPage = true;

        while (hasNextPage) {
            const response = await axios.get(`${GITHUB_API_BASE}/user/repos`, {
                headers: { Authorization: `token ${token}` },
                params: { per_page: 100, page }
            });

            const repoDetails = response.data.map((repo: any) => ({
                full_name: repo.full_name,
                owner: repo.owner.login,
                visibility: repo.private ? "private" : "public",
                clone_url: repo.clone_url,
                ssh_url: repo.ssh_url,
                created_at: repo.created_at,
                size: repo.size,
                permissions: repo.permissions,
            }));

            repos.push(...repoDetails);

            if (response.data.length < 100) {
                hasNextPage = false;
            }

            page++;
        }

        return repos;
    } catch (error) {
        console.error('Erreur lors de la récupération des dépôts GitHub :', error);
        return [];
    }
}

export async function createWebhook(repoFullName: string, token: string): Promise<void> {
    try {
        const payload = {
            name: "web",
            config: {
                url: "https://88.166.16.161:18001/services/github/webhook-events",////CHANGER PAR LURL PUBLIC DU SERVEUR
                content_type: "json",
                insecure_ssl: "0"
            },
            events: [
                "push",
                "pull_request",
                "issues",
                "issue_comment",
                "star",
                "fork",
                "create",
                "delete",
                "release",
                "pull_request_review",
                "pull_request_review_comment",
                "repository"
            ],
            active: true
        };

        const response = await axios.post(
            `https://api.github.com/repos/${repoFullName}/hooks`,
            payload,
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                    Accept: "application/vnd.github+json",
                    "Content-Type": "application/json"
                }
            }
        );

        console.log(`Webhook créé avec succès pour le dépôt ${repoFullName}`, response.data);
    } catch (error: any) {
        if (error.response) {
            console.error(`Erreur GitHub (${error.response.status}):`, error.response.data);
        } else {
            console.error(`Erreur lors de la création du webhook pour ${repoFullName}:`, error.message);
        }
    }
}


export async function saveGitHubUserToDB(userId: string, userData: any) {
    try {
        const userRef = doc(db, 'users', userId);
        const githubServiceRef = doc(collection(userRef, 'services'), 'github');
        await setDoc(githubServiceRef, {
            githubId: userData.id,
            githubLogin: userData.login,
            githubName: userData.name,
            githubEmail: userData.email,
            token: userData.token,
            createdAt: new Date().toISOString()
        });

        console.log(`GitHub data saved for user ${userId}`);
    } catch (error) {
        console.error('Erreur lors de la sauvegarde des infos GitHub dans Firestore:', error);
    }
}
