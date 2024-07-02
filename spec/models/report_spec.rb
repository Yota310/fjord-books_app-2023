# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#editable' do
    context 'ユーザーがレポートを所有している' do
      it '編集できる' do
        user = FactoryBot.create(:user)
        expect(FactoryBot.create(:report, user_id: user.id).editable?(user)).to be_truthy
      end
    end
    context 'ユーザーがレポートを所有していない' do
      it '編集できない' do
        expect(FactoryBot.build(:report).editable?(FactoryBot.build(:another_user))).to be_falsey
      end
    end
  end

  describe '#created_on' do
    it '作られた日付を取得' do
      expect(FactoryBot.build(:report, created_at: '2024-06-24 14:33'.in_time_zone).created_on).to eq Date.new(2024, 6, 24)
    end
  end

  describe '#save_mentions' do
    context 'レポートを新たに作成してメンション数が増える場合' do
      before do
        @before_report_count = FactoryBot.build(:mention_report).mentioning_reports.count
      end

      it 'メンションを保存することができる' do
        expect(@before_report_count).to eq 0
        user = FactoryBot.create(:user)
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = user.reports.create!(
          content: "http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します",
          title: 'メンションするレポート'
        )
        expect(mention_report.mentioning_reports.count).to eq 1
        expect(mention_report.mentioning_reports).to eq [mentioned_report]
      end
    end

    context 'レポートが存在していて初期値よりメンション数が増える場合' do
      before do
        mention_report = FactoryBot.create(:mention_report, content: '何もメンションしていない状態を編集します。')
        mention_report.save
        @before_report_count = mention_report.mentioning_reports.count
      end

      it '編集によってメンションしている数が増える' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
        expect(@before_report_count).to eq 0
        expect(mention_report.mentioning_reports.count).to eq 1
        expect(mention_report.mentioning_reports).to eq [mentioned_report]
      end

      it '二重でメンションしても１つのメンションになる' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
        mention_report.update!(content: "http://localhost:3000/reports/#{mentioned_report.id}私は重複してmentionedレポートを言及しますhttp://localhost:3000/reports/#{mentioned_report.id}")
        expect(@before_report_count).to eq 0
        expect(mention_report.mentioning_reports.count).to eq 1
        expect(mention_report.mentioning_reports).to eq [mentioned_report]
      end
    end
    context 'レポートが存在していて初期値よりメンション数が減る場合' do
      before do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
        mention_report.save
        @before_report_count = mention_report.mentioning_reports.count
      end

      it '編集によってメンションしている数が減る' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
        mention_report.update!(content: 'レポートの内容を変更します。これによってメンションしているレポートがなくなります')
        expect(@before_report_count).to eq 1
        expect(mention_report.mentioning_reports.count).to eq 0
        expect(mentioned_report.mentioned_reports.count).to eq 0
      end

      it '自分自身をメンションしても保存されない' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: "http://localhost:3000/reports/#{mentioned_report.id}私は編集によってmentionedレポートを言及します")
        mention_report.update!(content: "http://localhost:3000/reports/#{mention_report.id}私は自身を言及しますが保存されません")
        expect(@before_report_count).to eq 1
        expect(mention_report.mentioning_reports.count).to eq 0
      end
    end
  end
end
