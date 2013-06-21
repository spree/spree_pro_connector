class CreateAuguryEnvironments < ActiveRecord::Migration
  def change
    create_table :augury_environments do |t|
      t.string :url
      t.string :user
      t.string :token
      t.string :store_id
      t.string :environment
    end
  end
end
