require "ffaker"

Dir.glob(File.join(File.dirname(__FILE__), "/samples/**/*.rb")) do |c|
  Rails.configuration.cache_classes ? require(c) : load(c)
end

module Samples
  include Order
  include Shipment

  def self.orders
    actual  = order
    current = actual.clone
    current[:updated_at] = 1.day.from_now
    [actual, current]
  end

  def self.order
    {
      number: "R" + rand(999999999).to_s,
      item_total: 89.0,
      total: 115.39,
      state: "complete",
      adjustment_total: "26.39",
      user_id: 1653,
      created_at: "2013-03-08T14:06:02Z",
      updated_at: "2013-03-08T14:08:55Z",
      completed_at: "2013-03-08T14:08:55Z",
      payment_total: "0.0",
      shipment_state: "ready",
      payment_state: "paid",
      email: Faker::Internet.email,
      special_instructions: nil,
      locked_at: nil,
      bill_address: {
        id: 1073000120,
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
      line_items: [
        {
          id: 1070890209,
          quantity: 1,
          price: 89.0,
          variant_id: 20,
          variant: {
            id: 20,
            name: Faker::Lorem.sentence,
            product_id: 20,
            external_ref: Faker::Lorem.words(2).join("-").downcase,
            sku: Faker::Lorem.words(2).join("-").downcase,
            price: 89.0,
            weight: 0.251,
            height: 310.0,
            width: 37.0,
            depth: 100.0,
            is_master: true,
            cost_price: nil,
            permalink: Faker::Lorem.words(2).join("-").downcase
          }
        }
      ],
        payments: [
          {
            id: 14675,
            amount: 115.39,
            state: "complete",
            payment_method_id: 931422128,
            payment_method: {
              id: 931422128,
              name: "PayPal",
              environment: "production"
            }
          }
      ],
        shipments: [
          {
            id: 1053937740,
            tracking: nil,
            number: "H63404100777",
            cost: 26.39,
            shipped_at: nil,
            state: "ready",
            fulfilled_from: "PCH",
            order_id: "R578565446",
            shipping_method: {
              name: "UPS 3-5 Days",
              zone_id: 10,
              shipping_category_id: nil,
              pch_carrier: "UPS",
              tracking_url: nil
            },
            inventory_units: [
              {
                id: 24137,
                variant_id: 20,
                state: "sold"
              }
            ]
          }
      ],
        adjustments: [
          {
            id: 1073099188,
            amount: 26.39,
            label: "Shipping",
            mandatory: true,
            locked: true,
            eligible: true,
            originator_type: "Spree::ShippingMethod",
            adjustable_type: "Spree::Order"
          }
      ]
    }
  end

  def self.all
      [ OpenStruct.new(message: "order:persist"          , payload: Samples::Order.persist)          ,
        OpenStruct.new(message: "order:ship"             , payload: Samples::Order.ship)             ,
        OpenStruct.new(message: "order:capture"          , payload: Samples::Order.capture)          ,
        OpenStruct.new(message: "order:payment:captured" , payload: Samples::Order.payment_captured) ,
        OpenStruct.new(message: "shipment:confirmation"  , payload: Samples::Shipment.confirmation)  ]
  end
end

