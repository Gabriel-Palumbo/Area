import { Request, Response } from 'express';
import { addDoc, collection, doc, DocumentData, getDoc, getDocs, query, QueryDocumentSnapshot, QuerySnapshot, setDoc, Timestamp, updateDoc, where } from 'firebase/firestore';
import { db } from '../../../init_db';
import { SlackEvent } from '../models/model';
import { EventData } from '../../event';
import { getServiceReactions } from '../../utils';

/**
 * @description This function check if the slack App token get by the event
 * belongs to someone. If yes, it return the user id.
 * 
 * @param slackToken 
 * @returns user.id
 */
export async function saveSlackEvent(slackEvent: any, userId: string) {
    try {

        const eventDocRef = collection(db, 'events');
        const userEventDocRef = collection(db, `users/${userId}/services/slack/events`);

        const actionReactionMap = await getServiceReactions(userId, 'slack');
        const reaction = actionReactionMap[slackEvent.event.type as string];

        if (reaction) {
            const createdAt = Timestamp.fromDate(new Date());
    
            
            const event_details : EventData = {
                createdAt,
                name: 'slack',
                reaction,
                userId: userId,
                eventId: slackEvent.event_id,
                event: {
                    type: slackEvent.event.type || "",
                    text: slackEvent.event.text || "",
                    channelId: slackEvent.event.channel || "",
                },
                description: 'Vous avez été mentionné sur slack',
                channelId: '',
                author: 'bot slack',
            }
    
            await addDoc(eventDocRef, event_details);
            await addDoc(userEventDocRef, event_details);
            return true;
        }
        
    } catch (error) {
        console.log("(saveSlackEvent) Error: save the slack event ")
        return false;
    }
}
