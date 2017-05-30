class ChangeColumTypeToFlights < ActiveRecord::Migration[5.0]
  def change
    change_column :flights, :datetime, :date
  end
end
