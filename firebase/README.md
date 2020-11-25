# Firebase - Cloud Functions

## Installation

In order to work with the Google Cloud Functions you will need to install:

* NodeJS
* NPM
* Firebase CLI

You can find a reference to all of the mentioned resources on the [Get Started Docs by Google](https://firebase.google.com/docs/functions/get-started#set-up-node.js-and-the-firebase-cli).

## Coding

The source code of our function is located at `functions/src/index.ts`.

Please note that we group our functions within the `const v2`. This way we won't conflict with any functions that are being used for StepCalc App V1.

## Deployment

Once you finished coding, you can deploy your changes using `npm run deploy`.