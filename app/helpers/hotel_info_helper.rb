require 'sinatra/base'
require 'http'
require 'json'

class ::Hash
  def deep_merge(second)
    merger = proc { |_, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    merge(second.to_h, &merger)
  end
end

module Sinatra
  module HotelInfoHelper
    @@hotels_id_hash = {}
    @@location_id_hash = {}

    def get_supplier_data(uri)
        response = HTTP.get(uri)
        JSON.parse(response.body)
    end

    def update_records(hotel_record)
        if @@hotels_id_hash[hotel_record['id']]
            @@hotels_id_hash[hotel_record['id']] = hotel_record.deep_merge(@@hotels_id_hash[hotel_record['id']])
        else
            @@hotels_id_hash[hotel_record['id']] = hotel_record
        end

        update_loc_records(@@hotels_id_hash[hotel_record['id']])

    end

    def update_loc_records(hotel_record)
        # if old destination, update records
        hotel_record["destination_id"] = hotel_record["destination_id"].to_s
        if @@location_id_hash[hotel_record["destination_id"]]
            @@location_id_hash[hotel_record["destination_id"]][hotel_record["id"]] = hotel_record
        else
            # else create new dictionary for the destination
            @@location_id_hash[hotel_record["destination_id"]] = {hotel_record["id"] => hotel_record}
        end
    end

    def process_supplier_a_data(supplier_hotel_json)        
        for hotel_details in supplier_hotel_json
            #clean facility strings
            clean_facility_arr = []
            for facility_str in hotel_details['Facilities']
                facility_str.strip!
                if facility_str.eql?('WiFi')
                    facility_str.downcase!
                end
                clean_facility_arr << facility_str.split(/(?=[A-Z])/).reject(&:empty?).join(' ').downcase
            end

            hotel_record = {
                "id" => hotel_details['Id'],
                "destination_id" => hotel_details['DestinationId'],
                "name" => hotel_details['Name'],
                "location" => {
                    "lat" => hotel_details['Latitude'],
                    "lng" => hotel_details['Longitude'],
                    "city" => hotel_details['City']
                },
                "amenities" => {"general" => clean_facility_arr}
            }
            # populate record
            update_records(hotel_record)
        end        
    end

    def process_supplier_b_data(supplier_hotel_json)
        for hotel_details in supplier_hotel_json
            hotel_record = {
                "id" => hotel_details['hotel_id'],
                "destination_id" => hotel_details['destination_id'],
                "name" => hotel_details['hotel_name'],
                "location" => {
                    "address" => hotel_details['location']['address'],
                    "country" => hotel_details['location']['country']
                },
                "description" => hotel_details['details'],
                "amenities" => hotel_details['amenities'],
                "images" => hotel_details['images'],
                "booking_conditions" => hotel_details["booking_conditions"]
                }
            # populate record
            update_records(hotel_record)
        end        
    end

    def process_supplier_c_data(supplier_hotel_json)
        for hotel_details in supplier_hotel_json
            hotel_record = {
                "id" => hotel_details['id'],
                "destination_id" => hotel_details['destination'],
                "name" => hotel_details['name'],
                "location" => {
                    "lat" => hotel_details['lat'],
                    "lng" => hotel_details['lng'],
                },
                "description" => hotel_details['info']
            }
        end
    end

    def get_hotel_data()
        supplier_uri = [
            'https://api.myjson.com/bins/gdmqa',
            'https://api.myjson.com/bins/1fva3m',
            'https://api.myjson.com/bins/j6kzm'
        ]        
        
        # each supplier needs to be processed differently as the format returned is different i.e. needs ETL
        
        if  @@hotels_id_hash.empty?
            process_supplier_a_data(get_supplier_data(supplier_uri[0]))
            process_supplier_b_data(get_supplier_data(supplier_uri[1]))
            process_supplier_c_data(get_supplier_data(supplier_uri[2]))
        end
        # return the combined data
        return @@hotels_id_hash, @@location_id_hash
    end
  end
  helpers HotelInfoHelper
end