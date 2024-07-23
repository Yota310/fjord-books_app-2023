# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#editable' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }
    let!(:report){ FactoryBot.create(:report, user_id: user.id) }
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
    let!(:report){ FactoryBot.build(:report, created_at: '2024-06-24 14:33'.in_time_zone) }
    it '作られた日付を取得' do
      expect(report.created_on).to eq Date.new(2024, 6, 24)
    end
  end

  describe '#save_mentions' do
    context 'レポートを新たに作成してメンション数が変更される場合' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:mentioned_report) { FactoryBot.create(:report) }
      let!(:mention_report) { 
        content = <<~TEXT
          http://localhost:3000/reports/#{mentioned_report.id}
          私はmentionedレポートを言及します
        TEXT
        FactoryBot.create(:report, content:)
      }
      it 'メンションを保存することができる' do
        expect do
          content = <<~TEXT
            "http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します"
          TEXT
          @mention_report = user.reports.create!(
            title: 'メンションするレポート',
            content:
          ).to change { @mention_report.mentioning_reports }.from([]).to([mentioned_report])
        end
      end

      it '自分自身をメンションしても保存されない' do
        content = <<~TEXT
            http://localhost:3000/reports/#{mention_report.id}
            私は自身を言及しますが保存されません
          TEXT
        expect do
          mention_report.update!(content:)
        end
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report]).to([])
      end

      it '二重でメンションしても１つのメンションになる' do
        content = <<~TEXT
            http://localhost:3000/reports/#{mentioned_report.id}
            私は重複してmentionedレポートを言及しますhttp://localhost:3000/reports/#{mentioned_report.id}
          TEXT
        expect do
          mention_report.update!(content:)
        end
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report]).to([mentioned_report])
      end
    end

    context 'レポートが存在していて初期値とメンション対象が変わる場合' do
      let!(:mentioned_report) { FactoryBot.create(:report, title: 'メンションされるレポート') }
      let!(:add_mentioned_report) { FactoryBot.create(:report, title: '後からメンションするレポート') }
      let!(:lost_mentioned_report) { FactoryBot.create(:report, title: 'メンションされなくなるレポート') }
      let!(:mention_report) { 
        content = <<~TEXT
          http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します。
          そしてlost_mention_reportも言及します。
          http://localhost:3000/reports/#{lost_mentioned_report.id}
        TEXT
        FactoryBot.create(:report, content:)
      }
      it '編集によってメンションしているレポートが変わる' do
        expect do
          content = <<~TEXT
            更新することで私はmentionedレポートとadd_mentioned_reportを言及します。
            http://localhost:3000/reports/#{mentioned_report.id},http://localhost:3000/reports/#{add_mentioned_report.id}
          TEXT
          mention_report.update!(content:)
        end
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report, lost_mentioned_report]).to([mentioned_report, add_mentioned_report])
      end
    end
  end
end
