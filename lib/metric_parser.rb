require "csv"

class MetricParser

  def initialize(file)
    @file_path = File.expand_path(file)
  end

  def parse_container(container)
    parsed_file = CSV.read(@file_path, {:col_sep => "\t"})
    container_groups = parsed_file.group_by { |i| i[1] }
    
    @container = container_groups[container]

    container_hash = {}

    container_hash["container"] = container

    count = 0
    @total_ph = 0
    @total_nsl = 0
    @total_temp = 0
    @total_wl = 0
    @container.each do |day|
      @total_ph += day[2].to_f
      @total_nsl += day[3].to_f
      @total_temp += day[4].to_f
      @total_wl += day[5].to_f
      count += 1
    end
    avg_ph = @total_ph/count
    avg_nsl = @total_nsl/count
    avg_temp = @total_temp/count
    avg_wl = @total_wl/count


    container_hash["average_ph"] = avg_ph.round(2)
    container_hash["average_nutrient_solution_level"] = avg_nsl.round(2)
    container_hash["average_temp"] = avg_temp.round(2)
    container_hash["average_water_level"] = avg_wl.round(2)

    p container_hash

  end

  container_1 = self.new("data/metrics.tsv").parse_container("container1")
  container_2 = self.new("data/metrics.tsv").parse_container("container2")
  container_3 = self.new("data/metrics.tsv").parse_container("container3")

  if container_1["average_temp"] > container_2["average_temp"] && container_1["average_temp"] > container_3["average_temp"]
    p "#{container_1["container"]} has the highest average temperature."
  elsif container_2["average_temp"] > container_1["average_temp"] && container_2["average_temp"] > container_3["average_temp"]
    p "#{container_2["container"]} has the highest average temperature."
  else
    p "#{container_3["container"]} has the highest average temperature."
  end

end


# MetricParser.new("data/metrics.tsv").parse_container("container1")
# MetricParser.new("data/metrics.tsv").parse_container("container2")
# MetricParser.new("data/metrics.tsv").parse_container("container3")
