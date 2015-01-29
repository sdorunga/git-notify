# Nicaea

[logo](http://upload.wikimedia.org/wikipedia/commons/0/0d/COUNCIL_OF_NICEA_Fresco_in_the_Sistine_Salon_Vatican_t.jpg)

Small web-service to notify top contributors and users mentioned in the PR body.

# Getting set up

Copy the example `.env` file and fill in the required values

`cp ./.env.example ./.env`

Run `bundle exec rackup -p 3000` to start the service

In order to receive webhook payloads locally you can either manually send a [correctly
formated](https://developer.github.com/v3/activity/events/types/#pullrequestevent)
request using your favourite net library or save yourself some trouble and use
`ngrok`

Just run `brew cask install ngrok` and `ngrok 3000`. This will create a random
http and https address that tunnels to your localhost. This allows you to use
those urls as the webhook target and receive the payloads locally.

# Concepts

 * **Subscribers**
   Subscribers get notified on every PR on the repository. Good for repo maintainers
   but not so good if it's a busy codebase in a compnay
 * **Top contributors**
   The service pulls in a random chosen amount of contributors from the x number of
   contributors that are considered the most important.
 * **Notify flags**
   On the repository -- no notifications are issued if the flag is turned off
   Per user -- if turned off, only notifications for direct mentions are issued,
   otherwise you will be notified for every subscribed repo, mention and may be
   randomly selected if you are in the top contributers list.
