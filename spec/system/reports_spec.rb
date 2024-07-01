# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  before do
    user = User.create!(name: 'alice', email: 'alice@example.com', password: '123456', password_confirmation: '123456')
    @report = user.reports.create!(content: 'aliceの日報です。今日のお昼はうどんでした', title: 'aliceの今日の日報')
  end

  it 'create report' do
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: '123456'
    click_on 'ログイン'
    expect(page).to have_content 'ログインしました'
    visit reports_path
    click_on '日報の新規作成'
    fill_in 'タイトル', with: 'report1'
    fill_in '内容', with: 'ここで新しい日報を作成します。よろしくお願いいたします。'
    click_on '登録する'

    expect(page).to have_content '日報が作成されました。'
    expect(page).to have_content 'report1'
    expect(page).to have_content 'ここで新しい日報を作成します。よろしくお願いいたします。'
  end
  it 'edit report' do
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: '123456'
    click_on 'ログイン'
    expect(page).to have_content 'ログインしました'
    visit report_path(@report)
    click_on 'この日報を編集'
    fill_in 'タイトル', with: 'タイトルを編集した'
    fill_in '内容', with: '内容を編集'
    click_on '更新する'
    expect(page).to have_content '日報が更新されました。'
    expect(page).to have_content 'タイトルを編集した'
    expect(page).to have_content '内容を編集'
  end
  it 'delete report' do
    rc = Report.count
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: '123456'
    click_on 'ログイン'
    expect(page).to have_content 'ログインしました'
    visit report_path(@report)
    click_on 'この日報を削除'
    expect(page).to have_content '日報が削除されました。'
    expect(rc - Report.count).to eq 1
  end
end
