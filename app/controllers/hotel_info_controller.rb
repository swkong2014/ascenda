require_relative 'application_controller'
require_relative '../helpers/hotel_info_helper'
require 'http'
require 'json'

class HotelInfoController < ApplicationController      
    helpers Sinatra::HotelInfoHelper

    set :show_exceptions, false

    # pre-compute 2 hashes to store the data in memory to reduce query overhead
    # assumption: hotel infos are fairly static with infrequent updates
    # can consider migrating to interface with redis to expire data 
    @@hotels_destination_hash = {}
    @@hotels_id_hash = {}

    # uses class var in memory storage for data 
    def initialize
        super()
        init_data()
    end

    def init_data()
        # hot reloading doesn't trigger initialize,
        # this function has to be called manually to populate data      
        if @@hotels_id_hash.empty? || @@hotels_destination_hash
            @@hotels_id_hash, @@hotels_destination_hash = get_hotel_data()
        end
    end

    get '/hotel/' do
        # Specify the content type to return, json
        content_type :json
        init_data()
        @@hotels_id_hash.to_json
    end
    
    get '/hotel/:id' do
        content_type :json
        init_data()
        if @@hotels_id_hash["#{params['id']}"]
            return @@hotels_id_hash["#{params['id']}"].to_json
        else
            halt 404, {"error" => "404 Not Found"}.to_json
        end
    end

    get '/destination/' do
        # Specify the content type to return, json
        content_type :json
        init_data()
        @@hotels_destination_hash.to_json
    end

    get '/destination/:id' do
        # Specify the content type to return, json
        content_type :json
        init_data()
        if @@hotels_destination_hash["#{params['id']}"]
            return @@hotels_destination_hash["#{params['id']}"].to_json
        else
            halt 404, {"error" => "404 Not Found"}.to_json
        end
    end
end