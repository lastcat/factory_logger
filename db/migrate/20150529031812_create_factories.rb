class CreateFactories < ActiveRecord::Migration
  def change
    create_table :factories do |t|
      t.string :name

    end
    add_index :factories, :name
  end
end
