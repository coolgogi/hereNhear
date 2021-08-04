const functions = require('firebase-functions');
functions.logger.log("example", {a:1, b:2, c:"33", d:{e:4}})
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const admin = require("firebase-admin");
"parserOptions": {
    "ecmaVersion": 2018
}
let serviceAccount = require("./firebase-admin.json");
admin.initializeApp({ credential: admin.credential.cert(serviceAccount), });

await admin.messaging().sendMulticast({
  tokens: ["token_1", "token_2"],
  notification: {
    title: "Weather Warning!",
    body: "A new weather warning has been issued for your location.",
    imageUrl: "https://my-cdn.com/extreme-weather.png",
  },
});



var serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
