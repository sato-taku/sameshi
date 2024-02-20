class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.references :prefecture, foreign_key: true
      t.string :age_group
      t.string :avatar
      t.string :crypted_password
      t.string :salt
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
