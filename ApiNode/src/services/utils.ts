import { doc, getDoc } from "firebase/firestore";
import { db } from "../init_db";

export async function getServiceReactions(userEmail: string, service: string): Promise<any> {
    const serviceDocRef = doc(db, `users/${userEmail}/services/${service}`);
    const serviceDoc = await getDoc(serviceDocRef);

    if (serviceDoc.exists()) {
        const serviceData = serviceDoc.data();
        return serviceData.action_reactions || {};
    } else {
        console.error("No such service found");
        return {};
    }
}

