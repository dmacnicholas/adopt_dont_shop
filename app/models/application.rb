class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  validates :name, presence: true
  validates :address, presence: true
  validates :state, presence: true
  validates :city, presence: true
  validates :zip, presence: true

  def application_pending?(pet_id)
    application_status(pet_id) == "Pending"
  end

  def application_status(pet_id)
    pet_applications.find_by(pet_id: pet_id)&.status
  end

  def application_accepted
    write_attribute(:status, "Accepted")
    save
  end

  def application_rejected
    write_attribute(:status, "Rejected")
    save
  end

end
