# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { '今日のレポート' }
    content { 'aliceの日報です、日報を書きます。それぞれの機能のテストのために書きました。' }
    association :user

    factory :mentioned_report do
      title { 'メンションされるレポート' }
      content { 'この日報はメンションされる日報になります。' }
    end

    factory :mention_report do
      title { 'メンションするレポート' }
    end

    factory :lost_mentioned_report do
      title { 'メンションされなくなるレポート' }
      content { 'この日報はメンションされる日報になります。' }
    end

    factory :add_mentioned_report do
      title { '後からメンションをするレポート' }
    end
  end
end
