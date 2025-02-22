class AddStyleIdToBeers < ActiveRecord::Migration[7.2]
  def change
    add_reference :beers, :style, foreign_key: true
  end
end
