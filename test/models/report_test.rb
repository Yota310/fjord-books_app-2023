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
    assert_equal Date.new(2024, 5, 21), report.created_on
  end

  test 'save_mentions' do
    cherry_book = reports(:cherry_book)
    mention_report = reports(:mention_report)
    mention_report.content = "私はhttp://localhost:3000/reports/#{cherry_book.id}のレポートについて言及します"
    mention_report.save
    assert_equal 1, mention_report.mentioning_reports.count
    assert_equal cherry_book.id, mention_report.mentioning_reports[0].id

    another_mention_report = reports(:another_mention_report)
    another_mention_report.content = "私はhttp://localhost:3000/reports/#{mention_report.id}のレポートについて言及します"
    another_mention_report.save
    assert_equal 1, another_mention_report.mentioning_reports.count
    assert_equal mention_report.id, another_mention_report.mentioning_reports[0].id

    mention_report.update(content: '内容を編集')
    assert_equal '内容を編集', Report.find(mention_report.id).content
    assert_equal 0, Report.find(cherry_book.id).mentioned_reports.count

    mentioned_double_report = reports(:mentioned_double_report)
    mention_double_report = reports(:mention_double_report)
    mention_double_report.content = "私はこのレポートについて2重で言及しますhttp://localhost:3000/reports/#{mentioned_double_report.id}、http://localhost:3000/reports/#{mentioned_double_report.id}"
    mention_double_report.save
    assert_equal 1, mention_double_report.mentioning_reports.count
    assert_equal mentioned_double_report.id, mention_double_report.mentioning_reports[0].id

    self_mention_report = reports(:self_mention_report)
    self_mention_report.content = "自らに言及をしますhttp://localhost:3000/reports/#{self_mention_report.id}"
    assert_equal 0, Report.find(self_mention_report.id).mentioned_reports.count
  end
end
