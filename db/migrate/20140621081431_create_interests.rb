class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.integer :category_id
      t.boolean :selected, default: true

      t.timestamps
    end
    add_index :interests, [:user_id, :category_id], unique: true
  end
end
