# hubot-slack-link-manager
A Hubot script to store and search links posted to Slack using Firebase!

## Pre-installation
You will need to sign up for a Firebase account [here](firebase.google.com)

## Environment Variables

Set up the following env variables on your server (generally Heroku).

You can find information about each value [in the Firebase docs](https://firebase.google.com/docs/web/setup)

* `FIREBASE_API_TOKEN` - API token from Firebase
* `FIREBASE_AUTH_DOMAIN`
* `FIREBASE_DATABASE_URL`
* `FIREBASE_STORAGE_BUCKET`

## Installation

`$ npm i -S hubot-slack-link-manager`

```
# external-scripts.json
[
  ...
  "hubot-slack-link-manager"
]

```

## Commands

* `hubot save <link> | <description>`  - saves a link with the given description
* `hubot show links`  - show all saved links
* `hubot search links <query>`  - fuzzy match link description and query
* `hubot show user links <user>` - shows all links a user has posted
