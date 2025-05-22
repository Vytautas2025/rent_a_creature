class AddLocationToCreatures < ActiveRecord::Migration[7.1]
  def change
    add_column :creatures, :location, :string
  end
end
