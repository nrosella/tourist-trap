class CreateBoroughs < ActiveRecord::Migration
  def change
    create_table :boroughs do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
