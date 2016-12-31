# LoveTrack

Takes a POST request with some JSON payload, fetches the currently playing SWR3 song, and

* publishes the recently loved songs as RSS feed, or
* posts the event to a Slack channel.

The POST request is sent by a BIG red button in the living room.

## Details

1. Show some love:

  ```
  curl \
    -H "Content-Type: application/json" \
    -X POST \
    -d "{\"user\":\"@jfu\",\"sender\":\"SWR3\",\"timestamp\":\"$(gdate --iso-8601=seconds)\"}" \
    http://localhost:9292/love/
  ```

1. Extract the currently playing title from the radio station

1. Send the song to Slack

# TODO

* Build the button
* Set the slack picture to the thumbnail included in the SWR3 json
* Set the slack message's URL to the one included in the SWR3 json, so that we point to the artist and song
