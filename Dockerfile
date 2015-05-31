FROM ruby:2.2.2-onbuild

RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

CMD ["ruby", "parse_and_push.rb"]
