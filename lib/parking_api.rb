require 'open-uri'
require 'nokogiri'
require 'json'
require 'time'

class ParkingApi
  def self.call(env)
    [200, {"Content-Type"=>"application/json"}, StringIO.new(self.get_parking_spaces)]
  end

  CACHE_MAX_AGE = 120
  @base_url = 'http://www5.stadt-muenster.de/parkhaeuser/'
  @cache = {
    time: 0
  }

  def self.get_parking_spaces
    if Time.now.to_i - @cache[:time] < CACHE_MAX_AGE
      @cache.to_json
    else
      self.build_cache().to_json
    end
  end

  def self.build_cache
    parking_spaces = []
    doc = Nokogiri::HTML(open(@base_url))
    doc.css('area').each do |area|
      parking_spaces << {
        name: area['alt'],
        free: area['onclick'][/frei=[\d]+/].split('=')[1],
        total: area['onclick'][/gesamt=[\d]+/].split('=')[1],
        status: area['onclick'][/status=\w+/].split('=')[1]
      }
    end
    @cache = {
      time: Time.parse(doc.css('strong')[0].text).to_i,
      parking_spaces: parking_spaces
    }
    @cache
  end
end