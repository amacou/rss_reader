class AddWeightToUnreadEntry < ActiveRecord::Migration
  def change
    add_column :unread_entries, :weight, :string
  end
end
