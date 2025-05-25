import { Timestamp } from "firebase/firestore";

/**
 *  @description maketinfo
 */
export interface StockInfos {
    name: string;
    symbol: string;
    price: string;
    last_updated: Timestamp;
}
