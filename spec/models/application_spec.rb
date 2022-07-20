require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pet_applications) }
    it { should have_many(:pets).through(:pet_applications) }
  end

  describe 'validations' do    
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_presence_of(:address)}
    it { is_expected.to validate_presence_of(:state)}
    it { is_expected.to validate_presence_of(:city)}
    it { is_expected.to validate_presence_of(:zip)}
    it {should allow_value("In Progress").for(:status)}
    it {should allow_value("Pending").for(:status)}
    it {should allow_value("Accepted").for(:status)}
    it {should allow_value("Rejected").for(:status)}
  end

  describe 'instance methods' do
      it 'application_pending?' do
        shelter_1 = Shelter.create!(foster_program: true, name: "ABC Shelter", city: "Nashville", rank: 1)
        pet_1 = Pet.create!(adoptable: true, age: 3, breed: "Goldendoodle", name: "Daisy", shelter_id: shelter_1.id)
        application_1 = Application.create!(name: 'John', address: '123 Main Street', city: 'Nashville', state: 'TN', zip: 37067, description: "I want a nice dog.", status: "In Progress")  
        pet_application_1 = PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)

        application_1.update(status: "Approved")
        expect(application_1.application_pending?(pet_1.id)).to eq(true)
      end

      it 'application_accepted' do
        shelter_1 = Shelter.create!(foster_program: true, name: "ABC Shelter", city: "Nashville", rank: 1)
        pet_1 = Pet.create!(adoptable: true, age: 3, breed: "Goldendoodle", name: "Daisy", shelter_id: shelter_1.id)
        application_1 = Application.create!(name: 'John', address: '123 Main Street', city: 'Nashville', state: 'TN', zip: 37067, description: "I want a nice dog.", status: "In Progress")  
        pet_application_1 = PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)
        
        application_1.application_status(pet_1)
        expect(application_1.status).to eq('In Progress')

        application_1.application_accepted
        application_1.application_status(pet_1)
        expect(application_1.status).to eq('Accepted')
      end

      it 'application_rejected' do
        shelter_1 = Shelter.create!(foster_program: true, name: "ABC Shelter", city: "Nashville", rank: 1)
        pet_1 = Pet.create!(adoptable: true, age: 3, breed: "Goldendoodle", name: "Daisy", shelter_id: shelter_1.id)
        application_1 = Application.create!(name: 'John', address: '123 Main Street', city: 'Nashville', state: 'TN', zip: 37067, description: "I want a nice dog.", status: "In Progress")  
        pet_application_1 = PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)
        
        application_1.application_rejected
        application_1.application_status(pet_1)
        expect(application_1.status).to eq('Rejected')
      end

      it "Approved/Rejected Pets on one Application do not affect other Applications" do
        shelter_1 = Shelter.create!(foster_program: true, name: "ABC Shelter", city: "Nashville", rank: 1)
        pet_1 = Pet.create!(adoptable: true, age: 3, breed: "Goldendoodle", name: "Daisy", shelter_id: shelter_1.id)
        application_1 = Application.create!(name: 'John', address: '123 Main Street', city: 'Nashville', state: 'TN', zip: 37067, description: "I want a nice dog.", status: "In Progress")  
        pet_application_1 = PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)

        shelter_1 = Shelter.create!(foster_program: true, name: "ABC Shelter", city: "Nashville", rank: 1)
        pet_1 = Pet.create!(adoptable: true, age: 3, breed: "Goldendoodle", name: "Daisy", shelter_id: shelter_1.id)
        pet_2 = Pet.create!(adoptable: true, age: 7, breed: "Terrier", name: "Chewie", shelter_id: shelter_1.id)
        application_2 = Application.create!(name: 'Nancy', address: '123 Sky Street', city: 'Tucson', state: 'AZ', zip: 85705, description: "I love dogs.", status: "In Progress")  
        pet_application_2 = PetApplication.create!(pet_id: pet_1.id, application_id: application_1.id)
        pet_application_3 = PetApplication.create!(pet_id: pet_2.id, application_id: application_1.id)

        application_1.application_status(pet_1)
        expect(application_1.status).to eq('In Progress')

        application_1.application_accepted
        application_1.application_status(pet_1)
        expect(application_1.status).to eq('Accepted')

        application_2.application_status(pet_1)
        application_2.application_status(pet_2)
        expect(application_2.status).to eq('In Progress')
    end
  end

end
