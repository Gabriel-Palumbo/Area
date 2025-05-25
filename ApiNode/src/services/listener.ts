import { DocumentData, collection, deleteDoc, doc, getDoc, getDocs, onSnapshot, updateDoc } from "firebase/firestore";
import { db } from '../init_db';
import { handleGithubReaction } from "./github/reaction";
import { handleTelegramReaction } from "./telegram/reaction";
import { handleDiscordReaction } from "./discord/reactions";
import { handleSlackReaction } from "./slack/functions/reaction";
import { EventData } from "./event";
import { handleNewsReaction } from "./mediastack/reaction";
import { handleCryptoReaction } from "./coinmarketcap/coinmarketcap";
import { handleWeatherReaction } from "./weather/reaction";
import { handleFootballReaction } from "./football/reaction";
import { handleTimeReaction } from "./time/reaction";
import { handleNinjaQuotesReaction } from "./ninja/request";
import { handleStockReaction } from "./finnhub/reaction";
import { handleTravelTimeReaction } from "./googlemaps/reaction";

export async function listenForAllUsers() {

    const eventsCollectionRef = collection(db, 'events');

    onSnapshot(eventsCollectionRef, (snapshot) => {
        snapshot.docChanges().forEach(async (change) => {
            if (change.type === "added") {
                const newEvent = change.doc.data();
                console.log("New event added: ", newEvent);
                
                await processEvent(newEvent);
                
                const eventDocRef = doc(db, 'events', change.doc.id);
                try {
                    await deleteDoc(eventDocRef);
                    console.log(`Document ${change.doc.id} deleted successfully.`);
                } catch (error) {
                    console.error(`Error deleting document ${change.doc.id}: `, error);
                }
            }
        });
    });
}

async function processEvent(eventActionReaction: DocumentData) {
    const event = eventActionReaction as EventData;

    if (event.reaction) {
        for (const reaction of event.reaction) {
            try {
                
                handleGithubReaction(reaction, event);

                handleTelegramReaction(reaction, event);

                handleDiscordReaction(reaction, event);

                handleSlackReaction(reaction, event);
                
                handleNewsReaction(reaction, event);

                handleCryptoReaction(reaction, event);

                handleWeatherReaction(reaction, event);

                handleFootballReaction(reaction, event);

                handleTimeReaction(reaction, event);

                handleNinjaQuotesReaction(reaction, event);

                handleStockReaction(reaction, event);

                handleTravelTimeReaction(reaction, event);
    
            } catch (error) {
                console.error(`Error processing reaction "${reaction}" for user ${event.userId}:`, error);
            }
        }
    }

}
