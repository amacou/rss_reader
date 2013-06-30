class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.string :xml_url
      t.string :feed_type
      t.datetime :last_checked_at

      t.timestamps
    end

    add_index :feeds, :xml_url
  end
end
