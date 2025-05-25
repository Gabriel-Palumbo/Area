import { doc, getDoc } from "firebase/firestore";
import { EventData } from "../event";
import { db } from "../../init_db";
import { handleEvent } from "../sender";

const WEATHER_API_KEY = process.env.WEATHER_API_KEY;

function parseCurrentWeather(data: { location: any; current: any; }) {
    const location = data.location;
    const current = data.current;

    let message = `📍 **Météo actuelle pour ${location.name}, ${location.region}, ${location.country}**\n`;
    message += `🕒 Dernière mise à jour: ${current.last_updated}\n`;
    message += `🌡️ Température: ${current.temp_c}°C (Ressenti: ${current.feelslike_c}°C)\n`;
    message += `🌥️ Condition: ${current.condition.text}\n`;
    message += `💨 Vent: ${current.wind_kph} km/h (${current.wind_dir})\n`;
    message += `💦 Humidité: ${current.humidity}%\n`;
    message += `🌡️ Point de rosée: ${current.dewpoint_c}°C\n`;
    message += `🌫️ Visibilité: ${current.vis_km} km\n`;
    message += `📊 Pression: ${current.pressure_mb} mb\n`;
    message += `🌙 UV Index: ${current.uv}\n`;
    message += `🌬️ Rafales de vent: ${current.gust_kph} km/h\n`;

    return message;
}

export async function getCurrentWeather(ville : string) {
    try {
        const country = ville;

        const apiKey = process.env.WEATHER_API_KEY || WEATHER_API_KEY;
        if (!apiKey) {
            return console.error("no apiKey!");
        }

        const response = await fetch(`http://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${country}&aqi=no`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        const message = parseCurrentWeather(data);

        return message;
    } catch (error) {
        console.error('Error fetching current weather:', error);
        return null;
    }
}

function parseForecastData(forecastData: any) {
    let message = '';

    forecastData.forEach((day: { date: any; day: { maxtemp_c: any; mintemp_c: any; avgtemp_c: any; maxwind_kph: any; avghumidity: any; daily_will_it_rain: any; }; astro: { sunrise: any; sunset: any; moon_phase: any; moon_illumination: any; }; }) => {
        const date = day.date;
        const maxTemp = day.day.maxtemp_c;
        const minTemp = day.day.mintemp_c;
        const avgTemp = day.day.avgtemp_c;
        const maxWind = day.day.maxwind_kph;
        const humidity = day.day.avghumidity;
        const willItRain = day.day.daily_will_it_rain ? 'Oui' : 'Non';
        const sunrise = day.astro.sunrise;
        const sunset = day.astro.sunset;
        const moonPhase = day.astro.moon_phase;
        const moonIllumination = day.astro.moon_illumination;

        message += `📅 **Prévisions pour le ${date}**:\n`;
        message += `🌡️ Température: max ${maxTemp}°C, min ${minTemp}°C, moyenne ${avgTemp}°C\n`;
        message += `💨 Vent max: ${maxWind} km/h\n`;
        message += `💧 Humidité moyenne: ${humidity}%\n`;
        message += `🌧️ Va-t-il pleuvoir? ${willItRain}\n`;
        message += `🌄 Lever du soleil: ${sunrise}\n`;
        message += `🌆 Coucher du soleil: ${sunset}\n`;
        message += `🌙 Phase de la lune: ${moonPhase} (Illumination: ${moonIllumination}%)\n\n`;
    });

    return message;
}

export async function getForecast(ville : string) {
    try {
        const country = ville;
        const days = 3;

        const apiKey = process.env.WEATHER_API_KEY || WEATHER_API_KEY;
        if (!apiKey) {
            console.error("pas d apiKey");
            return [];
        }

        const response = await fetch(`http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${country}&days=${days}&aqi=no`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        const message = parseForecastData(data.forecast.forecastday);

        return message;
    } catch (error) {
        console.error('Error fetching forecast:', error);
        return [];
    }
}

export async function handleWeatherReaction(reaction: string, event: EventData) {
    try {
        let weatherData: any | null;

        if (!reaction) {
            return;
        }

        if (!event.userId) {
            return;
        }

        const docRef = doc(db, 'users', event.userId, 'services', 'weather');
        const docSnapshot = await getDoc(docRef);

        if (!docSnapshot.exists()) {
            return;
        }

        const data = docSnapshot.data();
        const ville = data?.ville;

        if (!ville) {
            return;
        }

        switch (reaction) {
            case 'weather/get_current_weather':
                weatherData = await getCurrentWeather(ville);
                break;
            case 'weather/get_forecast':
                weatherData = await getForecast(ville);
                break;
            default:
                console.warn(`Unknown weather reaction type: ${reaction}`);
                return;
        }

        if (weatherData) {
            
            const docRef = doc(db, 'users', event.userId, 'services', 'weather');
            const docSnapshot = await getDoc(docRef);

            if (!docSnapshot.exists()) {
                console.error(`No weather service found for user ${event.userId}`);
                return;
            }

            const data = docSnapshot.data();
            const sender = data?.sender as 'telegram' | 'discord' | 'slack';

            handleEvent(event.userId, weatherData, sender);
        } else {
            console.warn(`No data available for reaction ${reaction}`);
        }
    } catch (error) {
        console.error(`Error handling weather reaction for "${reaction}" with event ${event.userId}:`, error);
    }
}
