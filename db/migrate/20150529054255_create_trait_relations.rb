class CreateTraitRelations < ActiveRecord::Migration
  def change
    create_table :trait_relations do |t|
      t.integer :factory_id
      t.integer :trait_id
    end
  end
end
