class CreateUnreadEntries < ActiveRecord::Migration
  def change
    create_table :unread_entries do |t|
      t.integer :user_id
      t.integer :entry_id
      t.integer :subscription_id
      t.boolean :readed, default: false

      t.timestamps
    end
    add_index :unread_entries, :user_id
    add_index :unread_entries, :entry_id
    add_index :unread_entries, :subscription_id
  end
end
