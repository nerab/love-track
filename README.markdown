# LoveTrack

Takes a POST request with some JSON payload, fetches the currently playing SWR3 song, and posts the song to a Slack channel.

## Button

The POST request is sent by a BIG red button in the living room. It runs `button.py` on a C.H.I.P.

## Details

```
curl \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"user\":\"@jfu\",\"sender\":\"SWR3\",\"timestamp\":\"$(gdate --iso-8601=seconds)\"}" \
  http://localhost:9292/love/
```

## Development

In order to have WEBrick listen on all interfaces:

```bash
be rackup -o 0.0.0.0
```

# TODO

* Make the LED brighter
* Proper deployment of the C.H.I.P.
* Have an auth scheme for the POST so that we know who sent the request
* Set the slack picture to the thumbnail included in the SWR3 json
* Set the slack message's URL to the one included in the SWR3 json, so that we point to the artist and song
