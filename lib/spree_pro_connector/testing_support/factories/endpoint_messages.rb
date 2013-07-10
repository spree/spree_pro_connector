FactoryGirl.define do
  factory :endpoint_message, class: Spree::EndpointMessage do
    uri     "http://localhost:3000"
    token   "123"
    sequence :message_id
    message "test:test"
    payload  { |m| %Q{{"message":"test:test", "message_id":"#{m.message_id}"}} }
  end
end

