require "open-uri"
require "nokogiri"
require "json"
require "time"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

base_url = "http://www5.stadt-muenster.de/parkhaeuser/"
spaces = JSON.parse(open(File.join(File.dirname(File.expand_path(__FILE__)), 'parking_spaces.json')).read)


# parse the page
parking_spaces = spaces["features"].clone
ec_features = []

doc = Nokogiri::HTML(open(base_url))
fetch_time = Time.now.utc.iso8601

doc.css('area').each do |area|
  index = parking_spaces.index { |f| f["properties"]["name"] == area["alt"] }


  unless index == nil
    ec_feature = parking_spaces[index]["properties"]
    ec_feature["location"] = parking_spaces[index]["geometry"]
    ec_feature["location"]["type"].downcase!

    ec_feature.merge!({
      fetch_time: fetch_time,
      free: area['onclick'][/frei=[\d]+/].split('=')[1].to_i,
      total: area['onclick'][/gesamt=[\d]+/].split('=')[1].to_i,
      status: area['onclick'][/status=\w+/].split('=')[1]
    })
    ec_features << ec_feature.to_json
  end
end

puts ec_features.join("\n")
