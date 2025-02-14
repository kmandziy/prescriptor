class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.string :gender, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :doctors do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :prescriptions do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
