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
      Report.create!(
        user_id: user.id,
        content: 'content',
        title: 'title'
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
  before do
  end
  describe '#created_on' do
    let(:user) { User.create!(**params) }
    let(:params) do
      {
        name: 'alice',
        email: 'alice@example.com',
        password: '123456',
        password_confirmation: '123456'
      }
    end
    let(:report) { Report.create!(**report_params) }
    let(:report_params) do
      {
        user_id: user.id,
        content: 'content',
        title: 'title',
        created_at: 'Tue, 24 Jun 2024 14:33:07.146486000 JST +09:00'
      }
    end
    it '作られた日付を取得' do
      expect(report.created_on).to eq Date.new(2024, 6, 24)
    end
  end
  describe '#save_mentions' do
    let!(:user) { User.create!(**params) }
    let(:params) do
      {
        name: 'alice',
        email: 'alice@example.com',
        password: '123456',
        password_confirmation: '123456'
      }
    end
    let!(:mentioned_report) { Report.create!(**mentioned_report_params) }
    let(:mentioned_report_params) do
      {
        user_id: user.id,
        content: 'mentioned',
        title: 'title',
        created_at: 'Tue, 24 Jun 2024 14:33:07.146486000 JST +09:00'
      }
    end
    let!(:mention_report) { Report.create!(**mention_report_params) }
    let(:mention_report_params) do
      {
        user_id: user.id,
        content: "http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します",
        title: 'title',
        created_at: 'Tue, 24 Jun 2024 14:33:07.146486000 JST +09:00'
      }
    end
    it 'メンションを保存することができる' do
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
