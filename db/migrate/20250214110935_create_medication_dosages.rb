class CreateMedicationDosages < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_dosages do |t|
      t.references :medication, null: false, foreign_key: true
      t.references :dosage, null: false, foreign_key: true

      t.timestamps
      t.index [:medication_id, :dosage_id], unique: true
    end
  end
end
