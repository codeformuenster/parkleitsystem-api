require "parking_api"
if ENV['RACK_ENV'] == 'production'
  require 'newrelic_rpm'
end
run ParkingApi