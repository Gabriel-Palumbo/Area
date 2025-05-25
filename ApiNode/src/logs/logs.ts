import { Logging, Severity } from "@google-cloud/logging-min";

const projectId = 'soul-connection-e7a32';
const logName = 'serverTs';


/**
 * 
 * @description Init the client logging and publish logs INFO or ERROR in 
 * GCloud Logging. 
 * 
 * 
 * @param message 
 * @param id 
 * @param error? 
 */
export async function logs(
    message: string,
    functionName: string,
    error?: Object) {
        const logging = new Logging({projectId});
        const log = logging.log(logName);
        const metadata = {
            resource: {type: 'global'},
            severity: error ? 'ERROR' : 'INFO'
        }

        const entry = log.entry(metadata, message);
        async function writeLog() {
            await log.write(entry);
            console.log(`Logged: ${message}`);
        }
        writeLog();
}
