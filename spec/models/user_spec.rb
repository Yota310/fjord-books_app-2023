# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    let(:user) { User.new(email: 'alice@example.com', name: '') }
    context '名前が存在しない時' do
      it 'Eメールを返す' do
        expect(user.name_or_email).to eq 'alice@example.com'
      end
    end
    context '名前が存在する時' do
      it '名前を返す' do
        user.name = 'alice'
        expect(user.name_or_email).to eq 'alice'
      end
    end
  end
end
