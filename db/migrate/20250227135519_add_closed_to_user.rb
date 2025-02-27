class AddClosedToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :closed, :boolean
  end
end
