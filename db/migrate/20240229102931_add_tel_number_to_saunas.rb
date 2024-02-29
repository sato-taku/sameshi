class AddTelNumberToSaunas < ActiveRecord::Migration[7.1]
  def change
    add_column :saunas, :tel_number, :string
  end
end
