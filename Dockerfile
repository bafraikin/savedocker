FROM ruby:2.5.1

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y xvfb chromedriver vim
RUN apt-get install -y bundler git python-pip

RUN pip install awscli --upgrade --user
RUN echo 'export PATH=$PATH:/root/.local/bin' >> /root/.bashrc


ADD chromedriver /usr/local/bin/chromedriver
ADD .aws /root/.aws

WORKDIR /app
RUN mkdir /app/vendor 
ADD kimurai /app/vendor/kimurai
ADD Gemfile /app/Gemfile
ADD real.rb /app/real.rb
ADD URL /app/URL
RUN bundle install --gemfile=/app/Gemfile
