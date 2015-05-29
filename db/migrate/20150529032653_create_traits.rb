class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.string :name
      t.integer :factory_id

      t.timestamps null: false
    end
  end
end
