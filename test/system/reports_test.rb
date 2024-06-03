# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:cherry_book)
    @user = users(:alice)
    login_as(@user)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
    assert_text 'メンションの対象になるレポートです'
    assert_text 'おもろい'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'railsを学んだ'
    fill_in '内容', with: '面白い'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'railsを学んだ'
    assert_text '面白い'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'タイトル編集した'
    fill_in '内容', with: '内容編集した'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'タイトル編集した'
    assert_text '内容編集した'
  end

  test 'should destroy Report' do
    rc = Report.count
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_equal(-1, Report.count - rc)
  end
end
