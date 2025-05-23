class AddTypesToCreatures < ActiveRecord::Migration[7.1]
  def change
    add_column :creatures, :types, :string
  end
end
