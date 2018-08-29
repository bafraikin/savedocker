FROM ruby:2.5.1

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y xvfb iceweasel chromedriver
RUN apt-get install -y bundler git

#ADD xvfb-firefox /usr/bin/xvfb-firefox
#ADD chromedriver /usr/bin/chromedriver
#RUN rm /usr/bin/firefox
#RUN ln -s /usr/bin/xvfb-firefox /usr/bin/firefox

WORKDIR /app
RUN mkdir /app/vendor 
ADD kimurai /app/vendor/kimurai
ADD Gemfile /app/Gemfile
ADD duck.rb /app/duck.rb
ADD URL /app/URL
RUN bundle install --gemfile=/app/Gemfile

