require "mechanize"
require "time"
require "csv"
require "overpass_api_ruby"
require "json"
require "./lib/details_parser"

module ParkingScraper

  def self.overpass_to_geojson(overpass)
    if overpass.length == 1 and overpass[0][:type] == "node"
      return { type: :Point, coordinates: [overpass[0][:lon], overpass[0][:lat]] }
    else
      # first item contains the order of nodes..
      return { type: :Polygon, coordinates: [overpass[0][:nodes].map { |node_id|
        node = overpass[overpass.find_index { |i| i[:id] == node_id }]
        [ node[:lon], node[:lat] ]
      }] }
    end
  end

  overpass = OverpassAPI.new({json: true})
  # read csv containing osm ids..
  @osm_ids = {}
  CSV.foreach("./lib/parking_spaces.csv", headers: true, header_converters: :symbol) do |row|
    row[:underground] = (row[:underground] == "true")

    row[:geojson] = self.overpass_to_geojson(overpass.raw_query("[out:json];#{row[:osm_id]};out skel qt;>;out skel qt;"))

    @osm_ids[row.delete(:name).last] = row.to_hash
    #sleep 15
  end

  @agent = Mechanize.new

  def self.fetch_spaces
    page = @agent.get("http://www.stadt-muenster.de/tiefbauamt/parkleitsystem/")

    spaces = page.links_with(class: /parkingLink/).map do |link|
      # click the link for the page with details
      details_page = link.click

      # a div with id parkingStatus contains the free, total and time of last update
      # in this order
      free_total_lastupdate = details_page.search("#parkingStatus strong")

      other_detail_info = extract_detail_info(details_page)

      # assemble return for map function
      begin
        return_space = {
          name: link.text,
          free: free_total_lastupdate.shift.text.to_i,
          total: free_total_lastupdate.shift.text.to_i,
          details: other_detail_info,
          updated_at: Time.parse("#{free_total_lastupdate.shift.text} CET").utc.iso8601(3),
          fetch_time: Time.now.utc.iso8601(3)
        }.merge(@osm_ids[link.text])
      rescue NoMethodError => e
        return_space = {
          error: "error fetching data"
        }.merge(@osm_ids[link.text])
      end
      return_space
    end

    if !spaces.empty?

      # assemble GeoJSON FeatureCollection
      fc = { type: :FeatureCollection, features: spaces.map { |s|
        { type: :Feature, geometry: s.delete(:geojson), properties: s } }
      }
      File.write("data/parking_spaces_featurecollection.json", fc.to_json)

      # assemble parking spaces json without geometry
      File.write("data/parking_spaces.json", spaces.to_json)

      # create \n separated files
      File.write("data/parking_spaces_n.json", spaces.map { |s| s.to_json }.join("\n"))
      File.write("data/parking_spaces_featurecollection_n.json", fc[:features].map { |f| f.to_json }.join("\n"))

    end

  end

  def self.extract_detail_info(details_page)
    keys   = details_page.search('.description')
    values = details_page.search('.value')
    result = {}
    remove_sign = /[\n\t:]+/
    keys.each_with_index do |key, index|
      key_name = key.text.gsub(remove_sign, "")
      key_value = values[index].text.gsub(remove_sign, "")
      translated_key = DetailsParser.translate_key key_name
      result[translated_key] = DetailsParser.parse_details translated_key, key_value
    end
    result
  end

end
