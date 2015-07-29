class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :borough_id

      t.timestamps null: false
    end
  end
end
