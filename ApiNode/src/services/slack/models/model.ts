/**
 *  @description Save the Slack Event
 */
export interface SlackEvent {
    name: string;
    token: string;
    team_id: string;
    user_id: string;
    event_id: string;

    event: {
        type: string;       // message ? reaction_added ?
        subtype: string;    // file_share
        text: string;       /* si le message commence avec <@ c'est que c'est un PING */
        channel: string;
    }

    /* Set if it's a reaction */
    item: {},

    /* Set if it's a file_share */
    file: {}
}
