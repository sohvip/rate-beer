class AddActivityToBrewery < ActiveRecord::Migration[7.2]
  def change
    add_column :breweries, :active, :boolean
  end
end
