require 'clockwork'
require './lib/parking_scraper'

module Clockwork
  handler do |job|
    ParkingScraper::fetch_spaces
  end

  every(30.seconds, 'scrape.job')
end
