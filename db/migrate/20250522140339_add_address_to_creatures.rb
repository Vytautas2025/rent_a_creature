class AddAddressToCreatures < ActiveRecord::Migration[7.1]
  def change
    add_column :creatures, :address, :string
  end
end
