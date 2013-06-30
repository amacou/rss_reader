class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
    add_index :folders, :user_id
  end
end
