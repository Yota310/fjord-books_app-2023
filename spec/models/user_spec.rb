# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    let(:user) { User.new(email: 'alice@example.com', name: '') }
    it 'return email. if name does not exist' do
      expect(user.name_or_email).to eq 'alice@example.com'
    end
    it 'return name. if name exist' do
      user.update(name: 'alice')
      expect(user.name_or_email).to eq 'alice'
    end
  end
end
