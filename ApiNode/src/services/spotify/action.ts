import { collection, getDocs } from 'firebase/firestore';
import { Response } from 'express';
import { AuthenticatedRequest } from '../../auth/middelware';
import { db } from '../../init_db';

export async function storeSpotifyToken(req: AuthenticatedRequest, res: Response): Promise<Response> {
    console.log(req.body);
    try {
        const response = await fetch('https://accounts.spotify.com/api/token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                grant_type: 'client_credentials',
                client_id: req.body.spotifyClientId,
                client_secret: req.body.spotifyClientSecret
            }).toString()
        });
        const data = await response.json();
        return res.status(200).json({ success: true, message: 'Spotify token stored successfully', spotifyToken: data });
    } catch (error) {
        console.error('Error processing Spotify token:', error);
        return res.status(500).json({ success: false, error: 'Internal server error' });
    }
}



const pollingUsers = new Set();

async function pollSpotifyDataForUsers() {
    try {
        const usersRef = collection(db, 'users');
        const usersSnapshot = await getDocs(usersRef);

        // Iterate through each user document
        usersSnapshot.forEach(async (userDoc) => {
            const userId = userDoc.id;
            const userData = userDoc.data();
            const spotifyToken = userData.spotifyToken;

            if (spotifyToken && !pollingUsers.has(userId)) {
                console.log(`Starting Spotify polling for user: ${userId}`);
                pollingUsers.add(userId); // Mark user as being polled
                startPollingUserSpotifyData(userId, spotifyToken, userData.favoriteSongId);
            } else if (!spotifyToken) {
                console.log(`No Spotify token for user ${userId}`);
            }
        });
    } catch (error) {
        console.error('Error polling Spotify data for users:', error);
    }
}

async function startPollingUserSpotifyData(userId: string, spotifyToken: string, songId?: string) {
    while (true) {
        await fetchAndLogUserAlbums(userId, spotifyToken);
        if (songId) {
            await fetchAndLogSongLikedStatus(userId, spotifyToken, songId);
        }
        await delay(300000);
    }
}

async function fetchAndLogUserAlbums(userId: string, spotifyToken: string) {
    try {
        const response = await fetch('https://api.spotify.com/v1/me/albums', {
            method: 'GET',
            headers: { 'Authorization': `Bearer ${spotifyToken}` }
        });

        if (response.ok) {
            const data = await response.json();
            console.log(`User ${userId} Albums:`, data.items);
        } else {
            console.error(`Failed to fetch albums for user ${userId}: ${response.status}`);
        }
    } catch (error) {
        console.error(`Error fetching albums for user ${userId}:`, error);
    }
}

async function fetchAndLogSongLikedStatus(userId: string, spotifyToken: string, songId: string) {
    try {
        const response = await fetch(`https://api.spotify.com/v1/me/tracks/contains?ids=${songId}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${spotifyToken}`,
                'Content-Type': 'application/json'
            }
        });

        if (response.ok) {
            const data = await response.json();
            const isLiked = data[0];
            console.log(`User ${userId} Song Liked Status:`, isLiked);
        } else {
            console.error(`Failed to check liked status for user ${userId}: ${response.status}`);
        }
    } catch (error) {
        console.error(`Error checking liked status for user ${userId}:`, error);
    }
}

function delay(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
