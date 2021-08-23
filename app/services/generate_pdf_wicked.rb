class GeneratePdfWicked
  attr_reader :report_data

  MAIN_LAYOUT = 'layouts/pdf/main'
  MAIN_TEMPLATE = 'pdf/generic_tps_report'

  def call(report_data, file_path: Rails.root.join('tmp', 'pdf-report-wicked.pdf'))
    unless report_data.is_a? PdfReportData
      raise ArgumentError, 'report must be a PdfReportData struct'
    end

    @report_data = report_data

    document_html = build_pdf
    pdf_bytestream = WickedPdf.new.pdf_from_string(document_html)
    File.open(file_path, 'wb') { |f| f.write(pdf_bytestream) } if file_path.present?
    pdf_bytestream
  end

  private

  def build_pdf
    PdfRenderingController.new.render_to_string(
      template: MAIN_TEMPLATE,
      layout: MAIN_LAYOUT,
      locals: { report_data: report_data }
    )
  end

end