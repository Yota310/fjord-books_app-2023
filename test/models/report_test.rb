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
end
