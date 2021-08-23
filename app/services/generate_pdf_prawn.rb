class GeneratePdfPrawn
  include MoneyFormatter

  attr_reader :file_path, :report_data

  TOP_OF_PAGE = 720
  RIGHT_BOUNDARY_OF_PAGE = 540

  def call(report_data, file_path: Rails.root.join('tmp', 'pdf-report-prawn.pdf'))
    unless report_data.is_a? PdfReportData
      raise ArgumentError, 'report must be a PdfReportData struct'
    end

    @report_data = report_data

    document = build_pdf
    document.render_file(file_path) if file_path.present?
    document
  end

  private

  def build_pdf
    report_name = 'TPS Report'
    salesperson_name = report_data.salesperson_name
    company_name = report_data.company_name

    begin_date = report_data.date_range.first.strftime('%D')
    end_date = report_data.date_range.last.strftime('%D')

    # Have to redeclare this vars since self on this class can't be accessed within the Prawn::Document block
    table_column_widths = self.table_column_widths
    table_data = self.table_data
    table_costs_column_place = self.table_costs_column_place

    cost_total = format_currency(report_data.cost_total)

    Prawn::Document.new do
      bounding_box([0, bounds.top], width: 270, height: 52) do
        text report_name
        font('Helvetica', size: 14, style: :bold) { text salesperson_name }
      end

      bounding_box([RIGHT_BOUNDARY_OF_PAGE / 2, bounds.top], width: 270, height: 52) do
        text company_name, align: :right if company_name.present?
        text "#{begin_date} to #{end_date}", align: :right
      end

      table(table_data,
            header: true,
            column_widths: table_column_widths,
            width: RIGHT_BOUNDARY_OF_PAGE,
            cell_style: { border_width: 0.5, inline_format: true, padding: 1, size: 9 }
      ) do
        columns(table_costs_column_place).align = :right
      end

      move_down(20)
      contractor_invoice_y = y - 25
      bounding_box([0, contractor_invoice_y], height: 25, width: 270) do
        text('Total Amount:')
      end

      bounding_box([RIGHT_BOUNDARY_OF_PAGE / 2, contractor_invoice_y], height: 25, width: 270) do
        text(cost_total, align: :right)
      end

      # page_number_template = 'Page <page>'
      # page_number_options = {
      #   align: :right,
      #   at: [bounds.right - 150, bounds.bottom],
      #   padding: 5,
      #   size: 9,
      #   width: 150
      # }
      # number_pages page_number_template, page_number_options
    end
  end

  def table_column_widths
    [70, 370, 100]
  end

  def table_costs_column_place
    2
  end

  def table_data
    table_data =
      report_data
        .report_lines
        .map do |line|
        [
          line.reference_number,
          line.item_name,
          format_currency(line.cost)
        ]
      end

    total_cost = [
      { content: '<b>Total</b>', colspan: 2, align: :right },
      "<b>#{format_currency(report_data.cost_total)}</b>"
    ]

    [table_header] + table_data + [total_cost]
  end

  def table_header
    ['Reference #', 'Item Name', 'Amount'].map { |title| "<b>#{title}</b>" }
  end

end
