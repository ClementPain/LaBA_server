class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_date
      t.integer :duration
      t.string :location
      t.text :description
      t.float :price

      t.timestamps
    end
  end
end
