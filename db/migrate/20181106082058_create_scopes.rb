class CreateScopes < ActiveRecord::Migration[5.2]
  def change
    create_table :scopes do |t|
      t.string :cart
      t.string :product
      t.string :order
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
