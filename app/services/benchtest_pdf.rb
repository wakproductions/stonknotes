require 'benchmark'
class BenchtestPdf

  TIMES = 100

  def call
    report_data = GeneratePdfReportData.new.call

    # Decided not to use Benchmark gem because it seemed to be giving inaccurate results. I don't think the
    # ActionController rendering operation was getting recorded in the experiment time recording.
    #
    # Benchmark.bm do |b|
    #   b.report('Prawn') { TIMES.times { GeneratePdfPrawn.new.call(report_data) } }
    #   b.report('Wicked') { TIMES.times { GeneratePdfWicked.new.call(report_data) } }
    #   b.report('Grover') { TIMES.times { GeneratePdfGrover.new.call(report_data) } }
    # end
    #

    %w(Prawn Wicked Grover).map do |word|
      start = Time.current
      TIMES.times { "GeneratePdf#{word}".constantize.new.call(report_data) }
      elapsed = Time.current - start

      OpenStruct.new(
        label: word,
        time_elapsed: elapsed.round(6)
      )
    end
  end

  def self.print(report)
    # puts "\tuser\t\tsystem\ttotal\t\treal"
    # report.each do |r|
    #   puts "#{r.label}\t#{r.utime.round(6)}\t#{r.stime.round(6)}\t#{r.total.round(6)}\t#{r.real.round(6)}"
    # end
    puts "\ttime elapsed (s)"
    report.each { |r| puts "#{r.label}\t#{r.time_elapsed}" }
  end

end