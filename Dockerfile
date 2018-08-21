FROM debian:jessie

RUN apt-get update && apt-get install -y xvfb iceweasel
RUN apt-get install -y ruby bundler git
RUN gem install selenium-webdriver
RUN gem install watir-webdriver

ADD xvfb-firefox /usr/bin/xvfb-firefox
RUN rm /usr/bin/firefox
RUN ln -s /usr/bin/xvfb-firefox /usr/bin/firefox

#WORKDIR /app
ADD duck.rb /app/duck.rb
ADD URL /app/URL

