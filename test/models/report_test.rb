# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable?' do
    report = reports(:cherry_book)
    current_user = users(:alice)
    assert_equal true, report.editable?(current_user)

    another_user = users(:bob)
    assert_equal false, report.editable?(another_user)
  end

  test 'created_on' do
    report = reports(:cherry_book)
    report[:created_at] = 'Tue, 21 May 2024 14:33:07.146486000 JST +09:00'
    assert_equal 'Tue, 21 May 2024 14:33:07.146486000 JST +09:00'.to_date, report.created_on
  end

  test 'save_mentions' do
    mention_report = reports(:mention_report)
    mention_report[:content] = 'http://localhost:3000/reports/1'
    mention_report.save
    assert_equal 1, Report.find(1).mentioned_reports.count
    mention_report.update(content: '内容を編集')
    assert_equal '内容を編集', Report.find(2).content
    assert_equal 0, Report.find(1).mentioned_reports.count
  end
end
