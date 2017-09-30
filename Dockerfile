FROM ruby-2.4.2

RUN bundle

EXPOSE 8080

CMD thin start -p 8080 -b 0.0.0.0
