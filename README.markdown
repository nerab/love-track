# LoveTrack

Takes a POST request, fetches the currently playing SWR3 song, and posts the song to a Slack channel.

The POST request is sent by a BIG red button in the living room, running `button.py` on a C.H.I.P. or Raspberry Pi.

## Send Love

```
curl -X POST -d '' http://homer@localhost:9292/songs
```

where `homer` is a basic-auth user that is @-mentioned in the message. The password is ignored.

## Development

In order to have WEBrick listen on all interfaces:

```bash
be rackup -o 0.0.0.0
```

# TODO

* Deployment of the web app
* Detect the nearest Bluetooth device in order to find who's nearby
* Set the slack picture to the thumbnail included in the SWR3 json
* Set the slack message's URL to the one included in the SWR3 json, so that we point to the artist and song
