class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value
    end
    
    add_index :settings, :name, unique: true
  end
end
