class CreateDosages < ActiveRecord::Migration[7.1]
  def change
    create_table :dosages do |t|
      t.string :amount, null: false
      t.string :frequency, null: false
      t.string :default_duration, null: false

      t.timestamps
    end
  end
end
