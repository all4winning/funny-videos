class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :like
      t.integer :unlike

      t.timestamps
    end
  end
end
