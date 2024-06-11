require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { User.new }

    it 'should validate that email is present' do
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")

      user.email = 'john.doe@example.com'
      user.valid?
      expect(user.errors[:email]).not_to include("can't be blank")
    end

    it 'should validate that password is present' do
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")

      user.password = 'password123'
      user.valid?
      expect(user.errors[:password]).not_to include("can't be blank")
    end

    it 'is valid with valid attributes' do
      user.email = 'john.doe@example.com'
      user.password = 'password123'
      expect(user).to be_valid
    end
  end
end
