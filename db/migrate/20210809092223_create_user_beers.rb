class CreateUserBeers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_beers do |t|
      t.integer :user_grade
      t.references :user, null: false, foreign_key: true
      t.references :beer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
