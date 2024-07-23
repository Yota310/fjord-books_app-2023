# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    context '名前が存在しない時' do
      user = FactoryBot.build(:user, name: nil)
      it 'Eメールを返す' do
        expect(user.name_or_email).to eq user.email
      end
    end

    context '名前が存在する時' do
      user = FactoryBot.build(:user, name: 'alice')
      it '名前を返す' do
        expect(user.name_or_email).to eq 'alice'
      end
    end
  end
end
