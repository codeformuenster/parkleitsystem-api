require 'json'
require './lib/parking_scraper'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

class ParkingApi
  def self.call(env)
    [200, {"Content-Type"=>"application/json; charset=utf-8", "Access-Control-Allow-Origin"=>"*"}, StringIO.new(self.get_parking_spaces)]
  end

  CACHE_MAX_AGE = 60
  @cache = {
    fetch_time: 0
  }

  def self.get_parking_spaces
    if @cache[:fetch_time] != nil and Time.now.to_i - @cache[:fetch_time] < CACHE_MAX_AGE
      @cache.to_json
    else
      self.build_cache().to_json
    end
  end

  def self.build_cache
    parking_spaces = ParkingScraper::fetch_spaces

    fetch_time = Time.now.to_i

    @cache[:parking_spaces] = parking_spaces
    @cache[:fetch_time] = fetch_time
    @cache
  end
end
