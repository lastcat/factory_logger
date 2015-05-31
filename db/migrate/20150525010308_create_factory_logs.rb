class CreateFactoryLogs < ActiveRecord::Migration
  def change
    create_table :factory_logs do |t|
      t.integer :factory_id
      t.float :execution_time

      t.timestamps null: false
    end
  end
end
