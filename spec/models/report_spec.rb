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
    context 'レポートを新たに作成してメンション数が変更される場合' do
      it 'メンションを保存することができる' do
        user = FactoryBot.create(:user)
        mentioned_report = FactoryBot.create(:mentioned_report)
        expect do
          @mention_report = user.reports.create!(
            title: 'メンションするレポート',
            content: <<~TEXT
              "http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します"
            TEXT
          ).to change { @mantion_report.mentioning_reports }.from([]).to([mentioned_report])
        end
      end

      it '自分自身をメンションしても保存されない' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: <<~TEXT)
          http://localhost:3000/reports/#{mentioned_report.id}
          私はmentionedレポートを言及します
        TEXT
        expect do
          mention_report.update!(content: <<~TEXT)
            http://localhost:3000/reports/#{mention_report.id}
            私は自身を言及しますが保存されません
          TEXT
        end
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report]).to([])
      end

      it '二重でメンションしても１つのメンションになる' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: <<~TEXT)
          http://localhost:3000/reports/#{mentioned_report.id}
          私は編集によってmentionedレポートを言及します
        TEXT

        expect do
          mention_report.update!(content: <<~TEXT)
            http://localhost:3000/reports/#{mentioned_report.id}
            私は重複してmentionedレポートを言及しますhttp://localhost:3000/reports/#{mentioned_report.id}
          TEXT
        end
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report]).to([mentioned_report])
      end
    end

    context 'レポートが存在していて初期値とメンション対象が変わる場合' do
      it '編集によってメンションしているレポートが変わる' do
        mentioned_report = FactoryBot.create(:mentioned_report)
        add_mentioned_report = FactoryBot.create(:add_mentioned_report)
        lost_mentioned_report = FactoryBot.create(:mentioned_report)
        mention_report = FactoryBot.create(:mention_report, content: <<~TEXT)
          http://localhost:3000/reports/#{mentioned_report.id}私はmentionedレポートを言及します。
          そしてlost_mention_reportも言及します。
          http://localhost:3000/reports/#{lost_mentioned_report.id}
        TEXT
        expect {
          mention_report.update!(content: <<~TEXT)
            更新することで私はmentionedレポートとadd_mentioned_reportを言及します。
            http://localhost:3000/reports/#{mentioned_report.id},http://localhost:3000/reports/#{add_mentioned_report.id}
          TEXT
        }
          .to change { mention_report.reload.mentioning_reports }
          .from([mentioned_report, lost_mentioned_report]).to([mentioned_report, add_mentioned_report])
      end
    end
  end
end
