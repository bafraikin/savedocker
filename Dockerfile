FROM ruby:2.5.1

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y xvfb chromedriver vim
RUN apt-get install -y bundler git python-pip

RUN pip install awscli --upgrade --user
RUN echo 'export PATH=$PATH:/root/.local/bin' >> /root/.bashrc


#ADD xvfb-firefox /usr/bin/xvfb-firefox
ADD chromedriver /usr/local/bin/chromedriver
ADD config.sh /app/config.sh
#RUN rm /usr/bin/firefox
#RUN ln -s /usr/bin/xvfb-firefox /usr/bin/firefox

WORKDIR /app
RUN mkdir /app/vendor 
ADD kimurai /app/vendor/kimurai
ADD Gemfile /app/Gemfile
ADD real.rb /app/real.rb
ADD URL /app/URL
RUN bundle install --gemfile=/app/Gemfile

#RUN ruby retry.rb & sleep 20
#RUN export coucou=$(ps -eo pid,args | grep "sleep 50" | awk 'NR % 2 == 1' | cut -d" " -f 1-2 | bc)
#RUN echo $coucou
#RUN kill $coucou
#COPY app/response.json ./here.json
