# this code is still kind of smelly, need to refactor more
require "csv"
class MetricParser

  def initialize(file)
    file_path = File.expand_path(file)
    @parsed_file = CSV.read(file_path, {:col_sep => "\t", :headers => [:date, :container, :ph, :nsl, :temp, :water_level]})
  end

  def parse_container(container)

    container_groups = @parsed_file.group_by { |i| i[:container] }

    single_container = container_groups[container]
    container_hash = {}
    container_hash["container"] = container

    max_water_level_day = single_container.max_by { |x| x[:water_level] }
    max_water_level = max_water_level_day[:water_level]

    max_ph_day = single_container.max_by { |x| x[:ph] }
    max_ph = max_ph_day[:ph]

    container_totals = {
      count: 0,
      ph: 0,
      nsl: 0,
      temp: 0,
      water_level: 0
    }

    single_container.each do |day|
      container_totals[:ph] += day[:ph].to_f
      container_totals[:nsl] += day[:nsl].to_f
      container_totals[:temp] += day[:temp].to_f
      container_totals[:water_level] += day[:water_level].to_f
      container_totals[:count] += 1
    end

    container_hash["average_ph"] = (container_totals[:ph] / container_totals[:count]).round(2)
    container_hash["average_nutrient_solution_level"] = (container_totals[:nsl] / container_totals[:count]).round(2)
    container_hash["average_temp"] = (container_totals[:temp] / container_totals[:count]).round(2)
    container_hash["average_water_level"] = (container_totals[:water_level] / container_totals[:count]).round(2)
    container_hash["max_water_level"] = max_water_level
    container_hash["max_ph"] = max_ph
    container_hash
  end

  def parse_all
    all_metrics = {
      count: 0,
      ph: 0,
      nsl: 0,
      temp: 0,
      water_level: 0
    }

    @parsed_file.each do |day|
      all_metrics[:ph] += day[:ph].to_f
      all_metrics[:nsl] += day[:nsl].to_f
      all_metrics[:temp] += day[:temp].to_f
      all_metrics[:water_level] += day[:water_level].to_f
      all_metrics[:count] += 1
    end

    all_avg_hash = {}
    all_avg_hash["average_ph"] = (all_metrics[:ph]/all_metrics[:count]).round(2)
    all_avg_hash["average_nutrient_solution_level"] = (all_metrics[:nsl]/all_metrics[:count]).round(2)
    all_avg_hash["average_temp"] = (all_metrics[:temp]/all_metrics[:count]).round(2)
    all_avg_hash["average_water_level"] = (all_metrics[:water_level]/all_metrics[:count]).round(2)
    all_avg_hash
  end

  def highest_avg_temp
    container_1 = parse_container("container1")
    container_2 = parse_container("container2")
    container_3 = parse_container("container3")
    if container_1["average_temp"] > container_2["average_temp"] && container_1["average_temp"] > container_3["average_temp"]
      container_1
    elsif container_2["average_temp"] > container_1["average_temp"] && container_2["average_temp"] > container_3["average_temp"]
      container_2
    else
      container_3
    end
  end

  def highest_abs_water
    container_1 = parse_container("container1")
    container_2 = parse_container("container2")
    container_3 = parse_container("container3")
    if container_1["max_water_level"] > container_2["max_water_level"] && container_1["max_water_level"] > container_3["max_water_level"]
      container_1
    elsif container_2["max_water_level"] > container_1["max_water_level"] && container_2["max_water_level"] > container_3["max_water_level"]
     container_2
    else
     container_3
    end
  end

  def highest_abs_ph
    container_1 = parse_container("container1")
    container_2 = parse_container("container2")
    container_3 = parse_container("container3")
    if container_1["max_ph"] > container_2["max_ph"] && container_1["max_ph"] > container_3["max_ph"]
      container_1
    elsif container_2["max_ph"] > container_1["max_ph"] && container_2["max_ph"] > container_3["max_ph"]
      container_2
    else
      container_3
    end
  end

end

# container hashes
p "Container 1:"
p MetricParser.new("data/metrics.tsv").parse_container("container1")
p "-"*80
p "Container 2:"
p MetricParser.new("data/metrics.tsv").parse_container("container2")
p "-"*80
p "Container 3:"
p MetricParser.new("data/metrics.tsv").parse_container("container3")
p "-"*80

p "All Averages:"
p MetricParser.new("data/metrics.tsv").parse_all

# container with highest average temperature
container_temp = MetricParser.new("data/metrics.tsv").highest_avg_temp
p "#{container_temp["container"]} has the highest average temperature."

# container with highest absolute water level
container_water = MetricParser.new("data/metrics.tsv").highest_abs_water
p "#{container_water["container"]} has the highest absolute water level."

# container with highest absolute ph level
container_ph = MetricParser.new("data/metrics.tsv").highest_abs_ph
p "#{container_ph["container"]} has the highest absolute ph."

