class CreateSpreeEndpointMessages < ActiveRecord::Migration
  def change
    create_table :spree_endpoint_messages do |t|
      t.string :message_id
      t.string :uri
      t.string :payload
      t.string :message
      t.string :token
      t.string :parameters
      t.text :response_data

      t.timestamps
    end
    add_index :spree_endpoint_messages, :message_id, unique: true
  end
end
