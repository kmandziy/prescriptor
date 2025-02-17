class FakeDataSeederService
  def self.call(doctor_count: 20, patient_count: 50)
    new(doctor_count, patient_count).call
  end

  def initialize(doctor_count, patient_count)
    @doctor_count = doctor_count
    @patient_count = patient_count
  end

  def call
    seed_doctors
    seed_patients
    log_completion
  end

  private

  attr_reader :doctor_count, :patient_count

  def seed_doctors
    puts "Creating #{doctor_count} doctors..."
    doctor_count.times do
      user = create_user
      create_doctor(user)
    end
  end

  def seed_patients
    puts "Creating #{patient_count} patients..."
    patient_count.times do
      user = create_user
      create_patient(user)
    end
  end

  def create_user
    User.create!(
      email: Faker::Internet.unique.email,
      password: 'password123'
    )
  end

  def create_doctor(user)
    Doctor.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      phone: Faker::PhoneNumber.cell_phone,
      address: Faker::Address.full_address,
      user: user
    )
  end

  def create_patient(user)
    Patient.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      phone: Faker::PhoneNumber.cell_phone,
      address: Faker::Address.full_address,
      gender: Faker::Gender.binary_type,
      user: user
    )
  end

  def log_completion
    puts "Successfully created:"
    puts "- #{doctor_count} doctors"
    puts "- #{patient_count} patients"
  end
end
