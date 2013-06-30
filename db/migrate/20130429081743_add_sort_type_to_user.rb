class AddSortTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :sort_type, :string, :default => "DESC"
  end
end
