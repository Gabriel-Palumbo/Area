export interface GithubEvent {
    name: string;
    token: string;
    team_id: string;
    user_login: string;
    user_id: string;
    event_id: string;
    event: {
        type: string | string[] | undefined;
        subtype?: string;
        text: string;
        channel: string;
    };
    item?: {};
    file?: {};
}
