# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    name { 'alice' }
    sequence(:email) { |n| "alice#{n}@example.com" }
    password { '123456' }
    password_confirmation { '123456' }

    factory :another_user do
      name { 'bob' }
    end
  end
end
