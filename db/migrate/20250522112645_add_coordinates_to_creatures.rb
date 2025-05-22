class AddCoordinatesToCreatures < ActiveRecord::Migration[7.1]
  def change
    add_column :creatures, :latitude, :float
    add_column :creatures, :longitude, :float
    add_column :creatures, :address, :string
  end
end
