object false

child(@orders => :orders) do
  attributes *order_attributes
end

node(:since) { @since }
node(:count) { @count }
