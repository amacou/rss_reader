class AddSkipCountToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :skip_count, :integer, :default => 0
  end
end
