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

    max_water_level_day = @container.max_by { |x| x[5] }
    max_water_level = max_water_level_day[5]

    max_ph_day = @container.max_by { |x| x[2] }
    max_ph = max_ph_day[5]


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
    container_hash["max_water_level"] = max_water_level
    container_hash["max_ph"] = max_ph

    p container_hash

  end

  # container hashes

  p "Container 1:"
  container_1 = self.new("data/metrics.tsv").parse_container("container1")
  p "-"*80
  p "Container 2:"
  container_2 = self.new("data/metrics.tsv").parse_container("container2")
  p "-"*80
  p "Container 3:"
  container_3 = self.new("data/metrics.tsv").parse_container("container3")
  p "-"*80

  # container with highest average temperature

  if container_1["average_temp"] > container_2["average_temp"] && container_1["average_temp"] > container_3["average_temp"]
    p "#{container_1["container"]} has the highest average temperature."
  elsif container_2["average_temp"] > container_1["average_temp"] && container_2["average_temp"] > container_3["average_temp"]
    p "#{container_2["container"]} has the highest average temperature."
  else
    p "#{container_3["container"]} has the highest average temperature."
  end
  p "-"*80

  # container with highest absolute water level

  if container_1["max_water_level"] > container_2["max_water_level"] && container_1["max_water_level"] > container_3["max_water_level"]
    p "#{container_1["container"]} has the highest absolute water level."
  elsif container_2["max_water_level"] > container_1["max_water_level"] && container_2["max_water_level"] > container_3["max_water_level"]
    p "#{container_2["container"]} has the highest absolute water level."
  else
    p "#{container_3["container"]} has the highest absolute water level."
  end
  p "-"*80

  # container with highest absolute ph level for the one day (there is no range of dates)

  if container_1["max_ph"] > container_2["max_ph"] && container_1["max_ph"] > container_3["max_ph"]
    p "#{container_1["container"]} has the highest absolute ph."
  elsif container_2["max_ph"] > container_1["max_ph"] && container_2["max_ph"] > container_3["max_ph"]
    p "#{container_2["container"]} has the highest absolute ph."
  else
    p "#{container_3["container"]} has the highest absolute ph."
  end


  def parse_all
    parsed_file = CSV.read(@file_path, {:col_sep => "\t"})
    count = 0
    @all_ph = 0
    @all_nsl = 0
    @all_temp = 0
    @all_wl = 0
    parsed_file.each do |day|
      @all_ph += day[2].to_f
      @all_nsl += day[3].to_f
      @all_temp += day[4].to_f
      @all_wl += day[5].to_f
      count += 1
    end
    avg_ph = @all_ph/count
    avg_nsl = @all_nsl/count
    avg_temp = @all_temp/count
    avg_wl = @all_wl/count

    all_avg_hash = {}
    all_avg_hash["average_ph"] = avg_ph.round(2)
    all_avg_hash["average_nutrient_solution_level"] = avg_nsl.round(2)
    all_avg_hash["average_temp"] = avg_temp.round(2)
    all_avg_hash["average_water_level"] = avg_wl.round(2)

    p "-"*80
    p "All Averages:"
    p all_avg_hash

  end

  self.new("data/metrics.tsv").parse_all

end

