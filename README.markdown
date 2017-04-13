# LoveTrack

[![Build Status](https://travis-ci.org/nerab/love-track.svg?branch=master)](https://travis-ci.org/nerab/love-track)

Takes a POST request, fetches the currently playing SWR3 song, and posts the song to a Slack channel.

The POST request is sent by a BIG red button in the living room, running `button.py` on a C.H.I.P. or Raspberry Pi.

## Send Love

```
curl -X POST http://homer@localhost:9292/songs
```

where `homer` is a basic-auth user that is @-mentioned in the message. The password is ignored.

# Deployment

## Button

see [deployment/README.markdown](deployment/README.markdown)

## Web App

```
$ eval "$(docker-machine env production)"
$ docker-compose up -d
```

Alternatively, the image can also be built on a staging server and then promoted to the production server. The stages should be defined in `docker-stages.yml`.

```
$ eval "$(docker-machine env staging)"
$ docker-compose build
$ bundle exec rake docker:promote
```

Afterwards the image just has to be run:

```
$ eval "$(docker-machine env production)"
$ docker-compose start
```

## Development

In order to have WEBrick listen on all interfaces:

```bash
be rackup -o 0.0.0.0
```

# TODO

* Set the slack picture to the thumbnail included in the SWR3 json
* Set the slack message's URL to the one included in the SWR3 json, so that we point to the artist and song
* Add an 'love it too' button so that the Slack user gets it registered, too
* Detect the nearest Bluetooth device in order to find who's nearby
