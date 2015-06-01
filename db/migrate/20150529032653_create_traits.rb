class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.string :name
    end
  end
end
