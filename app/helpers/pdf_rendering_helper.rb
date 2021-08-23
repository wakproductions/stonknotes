module PdfRenderingHelper
  include MoneyFormatter

  def date_range_header(report_data)
    begin_date = report_data.date_range.first.strftime('%D')
    end_date = report_data.date_range.last.strftime('%D')

    "#{begin_date} to #{end_date}"
  end
end