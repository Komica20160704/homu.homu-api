FROM ruby:2.4.2

ENV LANG="C.UTF-8" INSTALL_PATH="/usr/src/app/"

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock $INSTALL_PATH

RUN bundle install

COPY . .

EXPOSE 8080

CMD thin start -p 8080
