class CreateFactoryLogs < ActiveRecord::Migration
  def change
    create_table :factory_logs do |t|
      t.string :name
      t.text :traits
      t.text :assos
      t.float :time
      t.integer :parent_id

      t.integer :factory_id
      t.float :exectuaion_time

      t.timestamps null: false
    end
  end
end
