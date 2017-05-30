class CreateFlights < ActiveRecord::Migration[5.0]
  def change
    create_table :flights do |t|
      t.integer :from
      t.integer :to
      t.datetime :datetime
      t.integer :duration

      t.timestamps
    end
  end
end
