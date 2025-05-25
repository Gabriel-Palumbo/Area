import { Timestamp } from "firebase/firestore";

/**
 *  @description Save the Slack Event
 */
export interface CoinInfos {
    name: string;
    symbol: string;
    price: string;
    last_updated: Timestamp;
}
