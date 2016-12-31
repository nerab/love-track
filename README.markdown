# LoveTrack

* Setup Huginn via Docker
* Configure Agents
* Have a BIG red button that sends a request when pressed

## Agents

1. One that takes a HTTP POST request:

  ```
  curl \
    -H "Content-Type: application/json" \
    -X POST \
    -d "{\"user\":\"@jfu\",\"sender\":\"SWR3\",\"timestamp\":\"$(gdate --iso-8601=seconds)\"}" \
    http://192.168.99.100:3000/users/1/web_requests/8/supersecretstring
  ```

1. One that extracts currently playing title from the radio station

1. One that sends the payload to Slack

Every agent feeds into the following one (except the last).

# TODO

* Build the button
* Deploy Huginn to production
* Put the agent config under version control
* Set the slack picture to the thumbnail included in the SWR3 json
* Set the slack message's URL to the one included in the SWR3 json, so that we point to the artist and song
