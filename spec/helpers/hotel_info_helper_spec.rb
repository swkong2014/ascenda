ENV['APP_ENV'] = 'test'

require 'test/unit'
require_relative '../../app/helpers/hotel_info_helper'

class HotelInfoTest < Test::Unit::TestCase
    include Sinatra::HotelInfoHelper

    def test_get_json_from_uri
        json_res = get_supplier_data("https://api.myjson.com/bins/gdmqa")
        assert_not_nil(json_res)
        assert_equal(json_res[0]['Id'], "iJhz")
    end 
    
    def test_get_hotel_data
        id_hash, loc_hash = get_hotel_data()
        assert_not_nil(id_hash)
        assert_not_nil(id_hash['iJhz'])
        assert_not_nil(id_hash['f8c9'])
        assert_not_nil(id_hash['SjyX'])

        assert_not_nil(loc_hash)
        assert_not_nil(loc_hash["1122"])
        assert_not_nil(loc_hash["1122"])
        assert_equal(loc_hash['5432'].length(), 2)
    end
end