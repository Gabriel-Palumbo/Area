import { Sticker } from "discord.js";
import { Timestamp } from "firebase/firestore";

/**
 *  @description models teams info
 */

export interface matchesInfos {
    date: Timestamp;
    team1: string;
    team2: string;
    symbol_team1?: string;
    symbol_team2?: string;
    stade?: string;
    team1_composition?: string[];
    team2_composition?: string[];
    last_updated: Timestamp;
}