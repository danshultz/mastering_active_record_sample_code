class CreateBeerDrinkers < ActiveRecord::Migration
  def change
    create_table :beer_drinkers do |t|
      t.string :name

      t.timestamps
    end

    create_table :beer_drinkers_beers do |t|
      t.integer :beer_drinker_id
      t.integer :beer_id
    end

  end
end
