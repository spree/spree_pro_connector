FactoryGirl.define do
  factory :endpoint_message, class: Spree::EndpointMessage do
    uri     "http://localhost:3000"
    token   "123"
    payload %Q{{"message":"test:test"}}  
  end
end

