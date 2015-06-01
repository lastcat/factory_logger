class CreateAssoRelations < ActiveRecord::Migration
  def change
    create_table :asso_relations do |t|
      t.integer :factory_id
      t.integer :asso_id
    end
  end
end
