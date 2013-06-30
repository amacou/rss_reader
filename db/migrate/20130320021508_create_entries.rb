class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :author
      t.string :link
      t.text :description
      t.datetime :published_at
      t.integer :feed_id

      t.timestamps
    end
  end
end
