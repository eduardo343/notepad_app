class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :emoji
      t.string :emoji_category
      t.references :notebook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
