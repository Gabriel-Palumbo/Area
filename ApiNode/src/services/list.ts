import { getDoc, doc, collection, getDocs, orderBy, deleteDoc, Timestamp } from "firebase/firestore";
import { db } from '../init_db';
import { Request, Response, query } from 'express';
import { AuthenticatedRequest } from '../auth/middelware';
import path from "path";
import fs from 'fs';

const loadAboutJson = () => {
    const filePath = path.join(__dirname, '../../about.json');
    const jsonData = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(jsonData);
};

export async function getAccountInfo(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not provided' });
        }

        const userRef = doc(collection(db, 'users'), userId);
        const userSnap = await getDoc(userRef);

        if (userSnap.exists()) {
            const userData = userSnap.data();
            return res.status(200).json({
                email: userData.email,
                firstName: userData.firstName,
                lastName: userData.lastName,
                isBanned: userData.isBanned
            });
        } else {
            return res.status(404).json({ message: 'User not found' });
        }
    } catch (error) {
        console.error('Error fetching account information:', error);
        return res.status(500).json({ message: 'Error retrieving account information' });
    }
};

export async function getUserServicesRouteSimple(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not provided' });
        }

        const servicesData = loadAboutJson().services;

        const servicesCollectionRef = collection(db, 'users', userId, 'services');
        const servicesSnapshot = await getDocs(servicesCollectionRef);
        const connectedServiceNames = servicesSnapshot.docs.map(doc => doc.id);

        const updatedServices = servicesData.reduce((acc: any, service: any) => {
            acc[service.name] = {
                name: service.name,
                is_connected: connectedServiceNames.includes(service.name),
                url: service.url,
            };
            return acc;
        }, {});

        return res.status(200).json(updatedServices);
    } catch (error) {
        console.error('Error fetching services:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}

interface Reaction {
    name: string;
    description: string;
}

interface Service {
    name: string;
    actions: Reaction[];
    reactions: Reaction[];
    url: string;
}

interface AboutData {
    services: Service[];
}

interface ServiceDataMap {
    [key: string]: {
        url: string;
        reactions: Record<string, string>;
        actions: Record<string, string>;
    };
}

const aboutData = loadAboutJson() as AboutData;

const serviceDataMap: ServiceDataMap = aboutData.services.reduce((map: ServiceDataMap, service) => {
    map[service.name] = {
        url: service.url,
        reactions: service.reactions.reduce((reactionMap, reaction) => {
            reactionMap[reaction.name] = reaction.description;
            return reactionMap;
        }, {} as Record<string, string>),
        actions: service.actions.reduce((actionMap, action) => {
            actionMap[action.name] = action.description;
            return actionMap;
        }, {} as Record<string, string>)
    };
    return map;
}, {} as ServiceDataMap);

export async function getUserServicesConnect(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not provided' });
        }

        const servicesCollectionRef = collection(db, 'users', userId, 'services');
        const servicesSnapshot = await getDocs(servicesCollectionRef);

        const connectedServiceNames = servicesSnapshot.docs.map(doc => doc.id);
        const servicesData = aboutData.services;

        const connectedServices = servicesData.reduce((acc: any, service: any) => {
            const serviceDoc = servicesSnapshot.docs.find(doc => doc.id === service.name);
            
            const actionReactions = serviceDoc?.data().action_reactions
            ? Object.entries(serviceDoc.data().action_reactions).map(([key, value]) => {
                const actions = Array.isArray(value) ? value.slice(0, -1) : [];
                const time = Array.isArray(value) ? value[value.length - 1] : null;

                return {
                    service: service.name,
                    action: key,
                    url: service.url,
                    description: serviceDataMap[service.name]?.actions[key] || "No description available",
                    reactions: actions.map((reaction: string) => {
                        const [servicePart, actionPart] = reaction.split("/");
                        const reactionObj = serviceDataMap[servicePart]?.reactions[actionPart];

                        return {
                            reaction,
                            description: reactionObj || "No description available",
                            imageUrl: serviceDataMap[servicePart]?.url || ""
                        };
                    }),
                    time
                };
            })
            : [];


            if (connectedServiceNames.includes(service.name) && actionReactions.length != 0) {
                acc = actionReactions
            }
            return acc;
        }, {});

        return res.status(200).json(connectedServices);
    } catch (error) {
        console.error('Error fetching connected services:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}


export async function getUserServicesRoute(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not provided' });
        }

        const servicesCollectionRef = collection(db, 'users', userId, 'services');
        const servicesSnapshot = await getDocs(servicesCollectionRef);

        const connectedServiceNames = servicesSnapshot.docs.map(doc => doc.id);
        const servicesData = loadAboutJson().services;

        const updatedServices = servicesData.reduce((acc: any, service: any) => {
            acc[service.name] = {
                ...service,
                is_connected: connectedServiceNames.includes(service.name),
            };
            return acc;
        }, {});

        return res.status(200).json(updatedServices);
    } catch (error) {
        console.error('Error fetching services:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}


export async function getUserServiceNames(userId: string): Promise<string[]> {
    try {
        const servicesCollectionRef = collection(db, 'users', userId, 'services');
        const servicesSnapshot = await getDocs(servicesCollectionRef);

        const connectedServiceNames = servicesSnapshot.docs.map(doc => doc.id);

        const servicesData = loadAboutJson().services;

        const serviceNames = servicesData
            .filter((service: { name: string; }) => connectedServiceNames.includes(service.name))
            .map((service: { name: any; }) => service.name);

        return serviceNames;
    } catch (error) {
        console.error('Error fetching service names:', error);
        return [];
    }
}

export async function getUserEventsSorted(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not provided' });
        }

        const servicesData = loadAboutJson().services;
        
        const connectedServiceNames = await getUserServiceNames(userId);
        const connectedServices = servicesData.filter((service: { name: string; }) => connectedServiceNames.includes(service.name));

        let allEvents: any[] = [];

        for (const service of connectedServices) {
            const eventsSnapshot = await getDocs(collection(db, 'users', userId, 'services', service.name, 'events'));
            const serviceEvents = eventsSnapshot.docs.map(doc => ({
                ...doc.data(),
                service: service.name,
                url: service.url
            }));

            allEvents = [...allEvents, ...serviceEvents];
        }

        allEvents.sort((a, b) => b.createdAt.seconds - a.createdAt.seconds);

        return res.status(200).json(allEvents);
    } catch (error) {
        console.error('Error fetching user events:', error);
        return res.status(500).json({ error: 'Failed to fetch events' });
    }
}


export async function deleteService(req: AuthenticatedRequest, res: Response): Promise<Response> {
    try {
        const userId = req.user?.userId;
        const { service } = req.body;

        if (!userId || !service) {
            return res.status(400).json({ message: "Invalid request parameters" });
        }

        const serviceDoc = doc(db, 'users', userId, "services", service);

        // Delete the service document
        await deleteDoc(serviceDoc);

        return res.status(200).json({ message: `Service ${service} deleted successfully.` });
    } catch (error) {
        console.error('Error deleting service:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}
