import { Request, Response } from 'express';
import { db } from '../../init_db';
import { doc, setDoc, collection, getDoc, where, query, getDocs, Timestamp, addDoc } from 'firebase/firestore';
import { getUsersWithGithubLogin, getGitHubUserByToken, getAllRepositories, createWebhook, saveGitHubUserToDB } from './githubService';
import { AuthenticatedRequest } from '../../auth/middelware';
import { GithubEvent } from './githubModel';
import { getServiceReactions } from '../utils';
import { EventData } from '../event';

export async function storeGitHubToken(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const { githubToken } = req.body;
    const userId = req.user?.userId;

    try {
        const githubUserData = await getGitHubUserByToken(githubToken);
        if (githubUserData) {
            await saveGitHubUserToDB(userId, { ...githubUserData, token: githubToken });

            const repos = await getAllRepositories(githubToken);

            const userRef = doc(db, 'users', userId);
            const githubServiceRef = doc(collection(userRef, 'services'), 'github');
            await setDoc(githubServiceRef, { repositories: repos, token:  githubToken, login: githubUserData.login});

            return res.status(200).json({
                message: 'GitHub token et infos utilisateur sauvegardés avec succès.',
                repositories: repos
            });
        } else {
            return res.status(400).json({ message: 'Impossible de récupérer les infos GitHub.' });
        }
    } catch (error) {
        console.error('Erreur lors du stockage des informations GitHub :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}

export async function getUserRepositories(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const userId = req.user?.userId;

    try {
        const userRef = doc(db, 'users', userId);
        const githubServiceRef = doc(collection(userRef, 'services'), 'github');

        const githubServiceSnapshot = await getDoc(githubServiceRef);

        if (githubServiceSnapshot.exists()) {
            const githubData = githubServiceSnapshot.data();
            const repoFullNames = githubData.repositories.map((repo: any) => repo.full_name); 
            return res.status(200).json({ repositories: repoFullNames });
        } else {
            return res.status(404).json({ message: 'Aucun dépôt trouvé pour cet utilisateur.' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des dépôts :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}

export async function createGitHubWebhook(req: AuthenticatedRequest, res: Response): Promise<Response> {
    const { repoFullName } = req.body;
    const userId = req.user?.userId;

    try {
        const userRef = doc(db, 'users', userId);
        const githubServiceRef = doc(collection(userRef, 'services'), 'github');
        
        const githubServiceSnapshot = await getDoc(githubServiceRef);
        const githubData = githubServiceSnapshot.data();

        await createWebhook(repoFullName, githubData?.token);

        await setDoc(githubServiceRef, {
            selectedWebhook: repoFullName
        }, { merge: true });

        return res.status(200).json({ message: `Webhook créé pour ${repoFullName}.` });
    } catch (error) {
        console.error(`Erreur lors de la création du webhook pour ${repoFullName} :`, error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}


export async function   handleWebhookEvents(req: Request, res: Response): Promise<Response> {
    const { repository, sender, ref, before, after, commits } = req.body;
    const action = req.headers['x-github-event'];

    try {
        if (action == "ping") {
            return res.status(200).send('ping reçu avec succès.');
        }
        if (!repository || !sender) {
            return res.status(400).json({ message: 'Données manquantes dans la requête.' });
        }

        const githubUsername = repository.owner.login;

        
        const matchingUsers = await getUsersWithGithubLogin(githubUsername);


        if (matchingUsers.length > 0 && typeof action === 'string') {
            const event = req.headers['x-github-event'];
            for (const matchingUser of matchingUsers) {
                const userId = matchingUser.userId;
                const actionReactionMap = await getServiceReactions(userId, 'github');
                const reaction = actionReactionMap[event as string];
        
                if (reaction) {
                    const eventsRef = collection(doc(db, 'users', userId, "services", "github"), 'events');
                    const eventsRef2 = collection(db, "events");
                    const createdAt = Timestamp.fromDate(new Date());
        
                    let githubEvent: EventData | null = null; // Initialisation
        
                    switch (event) {
                        case "push":
                            for (const commit of req.body.commits) {
                                githubEvent = {
                                    reaction,
                                    userId,
                                    name: req.body.repository.full_name,
                                    eventId: commit.id,
                                    channelId: ref,
                                    createdAt,
                                    author: req.body.sender.login,
                                    description: `Push by ${req.body.sender.login}: ${commit.message}`,
                                    event: {
                                        type: event,
                                        text: commit.message,
                                        channelId: ref,
                                    },
                                };
                                await setDoc(doc(eventsRef), githubEvent);
                                await addDoc(eventsRef2, githubEvent);
                            }
                            break;
                    
                        case "issues":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.issue.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Issue "${req.body.issue.title}" created by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: req.body.issue.title,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "fork":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.repository.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Repository forked by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: `Forked by ${req.body.sender.login}`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "star":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.sender.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Repository starred by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: `Starred by ${req.body.sender.login}`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "release":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.release.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Release "${req.body.release.name}" published by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: req.body.release.name,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "pull_request":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.pull_request.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Pull request "${req.body.pull_request.title}" ${req.body.action} by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: req.body.pull_request.title,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "pull_request_review":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.review.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Pull request reviewed by ${req.body.sender.login}: ${req.body.review.state}`,
                                event: {
                                    type: event,
                                    text: `Review state: ${req.body.review.state}`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "pull_request_review_comment":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.comment.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Comment on pull request by ${req.body.sender.login}: ${req.body.comment.body}`,
                                event: {
                                    type: event,
                                    text: req.body.comment.body,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "repository":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.repository.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Repository settings changed by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: `Repository settings update`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "issue_comment":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.comment.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `Comment on issue by ${req.body.sender.login}: ${req.body.comment.body}`,
                                event: {
                                    type: event,
                                    text: req.body.comment.body,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "create":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.repository.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `New ${req.body.ref_type} created by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: `Created ${req.body.ref_type}: ${req.body.ref}`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        case "delete":
                            githubEvent = {
                                reaction,
                                userId,
                                name: req.body.repository.full_name,
                                eventId: req.body.repository.id,
                                channelId: ref,
                                createdAt,
                                author: req.body.sender.login,
                                description: `${req.body.ref_type} deleted by ${req.body.sender.login}`,
                                event: {
                                    type: event,
                                    text: `Deleted ${req.body.ref_type}: ${req.body.ref}`,
                                    channelId: ref,
                                },
                            };
                            await setDoc(doc(eventsRef), githubEvent);
                            await addDoc(eventsRef2, githubEvent);
                            break;
                    
                        default:
                            console.log(`Unrecognized GitHub event type: ${event}`);
                    }
                                        
                } else {
                    console.log(`Pas d'action réaction pour ${userId} pour l'événement "${event}"`);
                }
            }
            return res.status(200).send('Événement webhook reçu avec succès.');
        } else {
            return res.status(404).json({ message: 'Utilisateur non trouvé.' });
        }
    } catch (error) {
        console.error('Erreur lors du traitement des événements webhook :', error);
        return res.status(500).json({ message: 'Erreur serveur.' });
    }
}
