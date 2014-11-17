FROM ruby:2.1.5-onbuild

CMD ["unicorn", "-Ilib", "-E production"]