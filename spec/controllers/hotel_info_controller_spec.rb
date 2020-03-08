ENV['APP_ENV'] = 'test'

require_relative '../../app/helpers/hotel_info_helper'
require_relative '../../app/controllers/hotel_info_controller'

require 'test/unit'
require 'rack/test'

class HotelInfoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    HotelInfoController
  end

  def test_list_all_hotels
    get '/hotel/'
    assert last_response.ok?
    assert last_response.body.include?('iJhz')
    assert last_response.body.include?('"amenities"')
    assert last_response.body.include?('"images":')
    assert last_response.body.include?('"location"')
    assert last_response.body.include?('"lat"')
    assert last_response.body.include?('"lng"')
    assert last_response.body.include?('"address"')
    assert last_response.body.include?('"city"')
    assert last_response.body.include?('"country"')
    assert last_response.body.include?('"description"')
    assert last_response.body.include?('"rooms"')
    assert last_response.body.include?('"site"')
    assert last_response.body.include?('"images"')
    assert last_response.body.include?('"booking_conditions"')
    assert last_response.body.include?('"Pets are not allowed."')
  end

  def test_get_hotel_by_id
    get '/hotel/iJhz'
    assert last_response.ok?
    assert last_response.body.include?('iJhz')
    assert last_response.body.include?('SjyX') == false
    assert last_response.body.include?('f8c9') == false
  end

  def test_get_all_by_location
    get '/destination/'
    assert last_response.ok?
    assert last_response.body.include?('iJhz')
    assert last_response.body.include?('SjyX')
    assert last_response.body.include?('f8c9')
  end

  def test_get_hotels_by_single_locations
    get '/destination/5432'
    assert last_response.ok?
    assert last_response.body.include?('iJhz')
    assert last_response.body.include?('SjyX') 
    assert last_response.body.include?('f8c9') == false
  end
end
