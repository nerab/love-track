FROM alpine:latest

RUN apk add --no-cache                         \
      build-base                               \
      ca-certificates                          \
      ruby                                     \
      ruby-dev                                 \
      ruby-bundler                             \
      ruby-io-console                          \
      ruby-irb                                 \
      ruby-rake                                \
      ruby-bigdecimal                          \
      ruby-json                                \
  && rm -rf /var/cache/apk/*                   \
  && rm -rf /usr/local/lib/ruby/gems/*/cache/* \
  && rm -rf ~/.gem

WORKDIR /app
ADD . /app
RUN bundle config --global silence_root_warning 1
RUN bundle install --jobs 4 --without=development test
CMD ["puma", "-e", "production"]
