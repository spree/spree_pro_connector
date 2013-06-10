module Samples
  module Shipment
    extend self

    def confirmation
      order = Samples.order
      {
        message: "shipment:confirmation",
        payload: {
          order_id: "1",
          shipment_number: order[:shipments][0][:number],
          tracking_number: "1ZV930E#{rand(999999999)}",
          carrier: "UPS",
          tracking_url: "http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_us&track.x=0&track.y=0&InquiryNumber1=1ZV930E90465912890",
          shipped_date: "2013-03-13T00:00:00Z",
          items: order[:line_items].map do |line_item|
            { part_number: line_item[:variant][:external_ref], quantity: line_item[:quantity], serial_numbers: nil }
          end
        }
      }
    end
  end
end

