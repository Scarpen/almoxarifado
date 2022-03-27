class CreateMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :quantity
      t.integer :status

      t.timestamps
    end

    add_index :materials, :name,  unique: true
  end
end
