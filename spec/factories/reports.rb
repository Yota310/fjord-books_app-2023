# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { '今日のレポート' }
    content { 'aliceの日報です、日報を書きます。それぞれの機能のテストのために書きました。' }
    association :user
  end
end
