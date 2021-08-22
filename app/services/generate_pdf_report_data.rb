PdfReportLine = Struct.new(
  :cost,
  :item_name,
  :reference_number,
  keyword_init: true
)

PdfReportData = Struct.new(
  :company_name,
  :cost_total,
  :date_range,
  :generated_date,
  :salesperson_name,
  :report_lines,
  keyword_init: true
)

class GeneratePdfReportData

  NUMBER_OF_LINES = 200

  def call
    report_attributes = {
      company_name: 'Acme Products Inc.',
      cost_total: cost_total,
      date_range: Date.new(2021,7,1)..Date.new(2021,7,31),
      generated_date: Date.new(2021,9,1),
      salesperson_name: "#{Faker::Name.last_name}, #{Faker::Name.first_name}",
      report_lines: report_lines,
    }

    PdfReportData.new(**report_attributes)
  end

  private

  def cost_total
    report_lines.sum { |line| line[:cost] }
  end

  def report_lines
    @report_lines ||=
      NUMBER_OF_LINES.times.map do
        PdfReportLine.new(
          cost: Random.rand(0..100000).to_f / 100,
          item_name: Faker::Company.bs.capitalize,
          reference_number: Random.rand(1000000..9999999).to_s
        )
      end
  end
end