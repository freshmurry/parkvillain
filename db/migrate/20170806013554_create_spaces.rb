class CreateSpaces < ActiveRecord::Migration[5.0]
  def change
    create_table :spaces do |t|
      t.string :space_type
      t.string :location_type
      t.string :address
      t.string :listing_name
      t.text :description
      t.boolean :is_unheated_space
      t.boolean :is_heated_space
      t.boolean :is_surveillance
      t.boolean :is_handi_accessible
      t.boolean :is_electric_space
      t.boolean :is_stairs
      t.boolean :is_elevator
      t.boolean :is_parking_attendant
      t.integer :price
      t.integer :tip
      t.boolean :active
      t.float :latitude
      t.float :longitude
      t.integer :instant, deafault: 1
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end