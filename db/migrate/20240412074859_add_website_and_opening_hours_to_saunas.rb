class AddWebsiteAndOpeningHoursToSaunas < ActiveRecord::Migration[7.1]
  def change
    add_column :saunas, :website, :string
    add_column :saunas, :opening_hours, :string
  end
end
