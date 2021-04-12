class CreateVillages < ActiveRecord::Migration[6.1]
  def change
    create_table :villages do |t|
      t.string :name
      t.string :zip_code
      t.string :insee_code
      t.string :email, default: "noemail@error.err"
      t.text :description

      t.timestamps
    end
  end
end
