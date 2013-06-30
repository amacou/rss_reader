class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :feed_id
      t.integer :folder_id
      t.string  :xml_url
      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :feed_id
    add_index :subscriptions, :folder_id
  end
end
