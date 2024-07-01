# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#editable' do
    let(:user) do
      User.create!(
        name: 'alice',
        email: 'alice@example.com',
        password: '123456',
        password_confirmation: '123456'
      )
    end
    let(:another_user) do
      User.create!(
        name: 'bob',
        email: 'bob@example.com',
        password: '123456',
        password_confirmation: '123456'
      )
    end
    let(:report) do
      user.reports.create!(
        content: 'aliceの日報です、日報を書きます。今回は編集が可能かのテストのために書きました。',
        title: '今日のレポート'
      )
    end
    context 'ユーザーがレポートを所有している' do
      it '編集できる' do
        expect(report.editable?(user)).to be_truthy
      end
    end
    context 'ユーザーがレポートを所有していない' do
      it '編集できない' do
        expect(report.editable?(another_user)).to be_falsey
      end
    end
  end
  describe '#created_on' do
    let(:user) do
      User.create!(
        name: 'alice',
        email: 'alice@example.com',
        password: '123456',
        password_confirmation: '123456'
      )
    end
    let(:report) do
      user.reports.create!(
        content: 'aliceの日報です、日報を書きます。今回はcreated_onがしっかり日付を取得できているのか確かめるテストのために書きました。',
        title: '今日のレポート'
      )
    end
    it '作られた日付を取得' do
      report.created_at = 'Tue, 24 Jun 2024 14:33:07.146486000 JST +09:00'
      expect(report.created_on).to eq Date.new(2024, 6, 24)
    end
  end
  describe '#save_mentions' do
    let!(:user) do
      User.create!(
        name: 'alice',
        email: 'alice@example.com',
        password: '123456',
        password_confirmation: '123456'
      )
    end
    let!(:mentioned_report) do
      user.reports.create!(
        content: 'この日報はメンションされる日報になります。',
        title: 'メンションされるレポート'
      )
    end
    let!(:mention_report) do
      user.reports.new(
        content: "http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します",
        title: 'メンションするレポート'
      )
    end
    it 'メンションを保存することができる' do
      mention_report.save
      expect(mention_report.mentioning_reports.count).to eq 1
      expect(mention_report.mentioning_reports[0].id).to eq mentioned_report.id
    end
    it '編集によって減らしたメンションが適用される' do
      mention_report.update(content: 'レポートの内容を変更します。これによってメンションしているレポートがなくなります')
      expect(mention_report.mentioning_reports.count).to eq 0
      expect(mentioned_report.mentioned_reports.count).to eq 0
    end
    it '編集によって増やしたメンションが適用される' do
      mention_report.update(content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
      expect(mention_report.mentioning_reports.count).to eq 1
      expect(mention_report.mentioning_reports[0].id).to eq mentioned_report.id
    end
    it '二重でメンションしても１つのメンションになる' do
      mention_report.update(content: "http://localhost:3000/reports/#{mentioned_report.id}私は重複してmentionedレポートを言及しますhttp://localhost:3000/reports/#{mentioned_report.id}")
      expect(mention_report.mentioning_reports.count).to eq 1
      expect(mention_report.mentioning_reports[0].id).to eq mentioned_report.id
    end
    it '自分自身をメンションしても保存されない' do
      mention_report.update(content: "http://localhost:3000/reports/#{mention_report.id}私は自身を言及しますが保存されません")
      expect(mention_report.mentioning_reports.count).to eq 0
    end
  end
end
