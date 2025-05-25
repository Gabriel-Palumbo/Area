import { collection, onSnapshot, doc, getDoc, getDocs, updateDoc, setDoc } from "firebase/firestore";
import axios from 'axios';
import { db } from '../../init_db';
import { EventData } from "../event";

export async function handleGithubReaction(reaction: string, event: EventData): Promise<void> {
    if (reaction === "github/create_issue") {
        try {
            const issueTitle = `Event: ${event.event.type} Detected!`;
            const issueBody = event.description;
            const userToken = await getUserGithubToken(event.userId);

            if (!userToken) {
                console.error(`GitHub token not found for user ${event.userId}`);
                return;
            }

            await createGithubIssue(event.name, issueTitle, issueBody, userToken);
        } catch (error) {
            console.error(`Failed to create GitHub issue for user ${event.userId}:`, error);
        }
    }
}


export async function createGithubIssue(repository: string, title: string, body: string, userToken: string) {
    const [owner, repo] = repository.split('/');

    try {
        const response = await axios.post(
            `https://api.github.com/repos/${owner}/${repo}/issues`,
            {
                title: title,
                body: body,
            },
            {
                headers: {
                    Authorization: `token ${userToken}`,
                    'Content-Type': 'application/json',
                },
            }
        );
        console.log(`Issue created in ${repository}: ${title}`);
        return response.data;
    } catch (error) {
        console.error("Error creating GitHub issue: ", error);
        throw error;
    }
}

export async function getUserGithubToken(userId: string): Promise<string | null> {
    try {
        const userDocRef = doc(db, 'users', userId, 'services', 'github');
        const userDocSnap = await getDoc(userDocRef);

        if (userDocSnap.exists()) {
            const userData = userDocSnap.data();
            return userData.token || null;
        }
        console.log("User GitHub token not found.");
        return null;
    } catch (error) {
        console.error("Error fetching GitHub token:", error);
        throw error;
    }
}
