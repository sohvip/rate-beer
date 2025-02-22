class RemoveOldStyleFromBeers < ActiveRecord::Migration[7.2]
  def change
    remove_column :beers, :old_style, :string
  end
end
