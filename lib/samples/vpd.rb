require "bson"
require "ffaker"

module Samples
  module VPD
    extend self

    def ready
      full_payload = {
        message_id: BSON::ObjectId.new.to_s,
        message: "shipment:ready",
        payload: {
          shipment: {
            number: "H" + rand(999999999).to_s,
            order_number: "R" + rand(999999999).to_s,
            email: Faker::Internet.email,
            ship_address: {
              id: 1073000121,
              firstname: Faker::Name.first_name,
              lastname: Faker::Name.last_name,
              address1: Faker::AddressUS.street_address,
              address2: "",
              city: Faker::AddressUS.city,
              zipcode: Faker::AddressUS.zip_code,
              phone: Faker::PhoneNumber.phone_number,
              company: nil,
              alternative_phone: nil,
              country_id: 214,
              state_id: 889445952,
              state_name: nil,
              country: {
                id: 214,
                iso_name: "UNITED STATES",
                iso: "US",
                iso3: "USA",
                name: "United States",
                numcode: 840
              },
              state: {
                abbr: "NY",
                country_id: 214,
                id: 889445952,
                name: "New York"
              }
            },
            shipping_method: {
              id: 123123123,
              name: "USPS 6-10 days"
            },
          },
          order: {}
        },
        parameters: [
          {
            name: "vpd.customer_id",
            value: "404400"
          }
        ]
      }
      full_payload[:payload][:shipment].merge items
      full_payload
    end

    private 

    def items
      items = (0..(rand(4) + 1)).map do |i|
        {
          quantity: 1 + rand(10),
          product: {
            id: 1 + rand(999999999),
            name: Faker::Lorem.sentence(1 + rand(4)),
            variant: {
              id: 1 + rand(999999999),
              sku: Faker::Lorem.word.upcase
            }
          }
        }
      end
      { items: items }
    end
  end
end

