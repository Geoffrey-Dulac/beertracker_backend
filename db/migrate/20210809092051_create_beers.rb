class CreateBeers < ActiveRecord::Migration[6.1]
  def change
    create_table :beers do |t|
      t.string :name
      t.float :degrees
      t.integer :grade
      t.string :kind
      t.references :brewer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
