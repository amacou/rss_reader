class AddEtagAndErrorCountToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :etag, :string
    add_column :feeds, :error_count, :integer, :default => 0
  end
end
