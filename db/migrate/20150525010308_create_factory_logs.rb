class CreateFactoryLogs < ActiveRecord::Migration
  def change
    create_table :factory_logs do |t|
      t.integer :factory_id
      t.string :factory_name
      t.float :execution_time
      t.float :logging_time
    end
  end
end
