require "csv"

class MetricParser

  def initialize(file)
    @file_path = File.expand_path(file)
  end

  def parse_container(container)
    parsed_file = CSV.read(@file_path, {:col_sep => "\t"})
    container_groups = parsed_file.group_by { |i| i[1] }
    @container = container_groups[container]
    count = 0
    @total_ph = 0
    @container.each do |day|
      @total_ph += day[2].to_f
      count += 1
    end
    avg_ph = @total_ph/count
    p avg_ph.round(2)
  end

end


MetricParser.new("data/metrics.tsv").parse_container("container1")
MetricParser.new("data/metrics.tsv").parse_container("container2")
MetricParser.new("data/metrics.tsv").parse_container("container3")