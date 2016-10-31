# hubot-slack-link-manager
A Hubot script to store and search links posted to Slack using Firebase!

## Pre-installation
You will need to sign up for a Firebase account [here](firebase.google.com)

You will then need to init a Firebase App instance for your Hubot.

Generally I do this by creating an `_init.coffee` file in the `scripts` directory.
This script will always be run first, and there you can init your Firebase App.

Example contents:

```coffeescript
# _init.coffee
Firebase = require 'firebase'
config = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.FIREBASE_DATABASE_URL,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
}
Firebase.initializeApp(config)
```

## Installation

`$ npm i -S hubot-slack-link-manager`

```json
// external-scripts.json
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

## Usage

This script will listen for any URL posted in rooms that Hubot is a member of.
It will make a naive GET request to the URL in an attempt to get info about the page from `og` tags.
Falls back to the `<title>` tag, or if the request itself fails, `null` is saved as the description.

Users can also manually save links.

## Contributing

* Make a pull request!
