class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.integer :score
      t.integer :beer_id

      t.timestamps
    end
  end
end
