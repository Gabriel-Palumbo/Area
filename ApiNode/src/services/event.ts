import { Timestamp } from "firebase/firestore";

export interface EventData {
    name: string;                  
    description: string;           
    userId: string;                
    eventId: string;               
    channelId: string;             
    createdAt: Timestamp;          
    author: string;                
    reaction: string;              
    event: {
        type: string;              
        text: string;              
        channelId: string;        
    };
}