import { TELEGRAM_API_URL } from "./listener";

export async function sendMessageTelegram(chatId: number, message: string) {
    try {
        const response = await fetch(`${TELEGRAM_API_URL}/sendMessage`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                chat_id: chatId,
                text: message,
            }),
        });

        const data = await response.json();

        if (data.ok) {
            console.log('Message sent successfully:', data);
        } else {
            console.error('Failed to send message:', data);
        }
    } catch (error) {
        console.error('Error sending message:', error);
    }
}