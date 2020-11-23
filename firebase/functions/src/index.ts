// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access Cloud Firestore.
import * as admin from 'firebase-admin';
admin.initializeApp();

// Store Cloud Firestore instance as const
const db = admin.firestore();

// Separate Collection References (Good Practice)
const contentsRef = db.collection('contents');

export const v2 = {
    getContents: functions.region('europe-west3').https.onCall(async (data, context) => {
        // We don't use the offset yet, but it can be retrieved this way:
        // const offset = data.offset;
        const contents = await contentsRef.get();
        return contents.docs.map((doc) => doc.id);
    }),
}
