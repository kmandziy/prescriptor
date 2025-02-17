class Doctor < ApplicationRecord
  has_many :prescriptions
  belongs_to :user
end
