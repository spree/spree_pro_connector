class CreateSpreeEndpointMessages < ActiveRecord::Migration
  def change
    create_table :spree_endpoint_messages do |t|
      t.string :uri
      t.string :payload
      t.string :message
      t.string :token
      t.string :parameters

      t.timestamps
    end
  end
end
