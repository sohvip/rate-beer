class RenameBeerStyleColumn < ActiveRecord::Migration[7.2]
  def change
    rename_column :beers, :style, :old_style
  end
end
