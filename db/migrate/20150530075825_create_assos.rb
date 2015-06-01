class CreateAssos < ActiveRecord::Migration
  def change
    create_table :assos do |t|
      t.string :name
      t.integer :factory_id
    end
  end
end
