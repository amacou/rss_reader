class AddLastModifiedAtToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :last_modified_at, :datetime
  end
end
