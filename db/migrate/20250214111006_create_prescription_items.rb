class CreatePrescriptionItems < ActiveRecord::Migration[7.1]
  def change
    create_table :prescription_items do |t|
      t.references :prescription, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.references :dosage, null: false, foreign_key: true
      t.integer :duration, null: false
      t.decimal :cost, precision: 10, scale: 2, null: false

      t.timestamps
      t.index [:prescription_id, :medication_id], unique: true
    end
  end
end
