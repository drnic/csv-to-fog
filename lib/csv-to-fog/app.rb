require "optparse"
require "csv"
require "yaml"

class CsvToFog::App
  attr_reader :fog_file

  def self.run(args)
    key = nil
    unparsed_mappings = []
    args = OptionParser.new do |opts|
      opts.banner = "csv-to-fog {options} path/to/file.csv"
      opts.separator ""
      opts.separator "Options are ..."

      opts.on_tail("-h", "--help", "-H", "Display this help message.") do
        puts opts
        exit
      end

      opts.on '--key="Student #"', '-k',
        'CSV Header Key to become the Fog key',
        lambda { |value| key = value }
      opts.on '--map="aws_access_key_id:Master Key"', '-m',
      'Map "Fog key:CSV Header Key"',
        lambda { |value| unparsed_mappings << value }
      opts.environment('RAKEOPT')
    end.parse(args)

    file_path = args.shift
    app = self.new(file_path, key, unparsed_mappings)
    app.load_file_and_validate!
    app.run
    puts app.fog_file.to_yaml
  end

  def initialize(file_path, key, unparsed_mappings)
    @file_path = file_path
    @key = key
    @mappings = parse_mappings(unparsed_mappings)
  end

  def parse_mappings(unparsed_mappings)
    unparsed_mappings.inject([]) do |mappings, mapping|
      fog, csv = mapping.split(":")
      if !csv || csv == ""
        $stderr.puts "Skipping --map \"#{mapping}\""
      else
        mappings << [fog, csv]
      end
      mappings
    end
  end

  def load_file_and_validate!
    errors = false
    unless @key
      $stderr.puts "--key is required"
      errors = true
    end
    if @mappings.size == 0
      $stderr.puts "--map is required"
      errors = true
    end
    if !@file_path
      $stderr.puts "Must pass path to CSV file"
      errors = true
    elsif !File.exists?(@file_path)
      $stderr.puts "File #{@file_path} doesn't exist"
      errors = true
    end
    exit 1 if errors

    @rows = []
    CSV.foreach(@file_path, headers: true) do |row|
      @rows << row
    end
  end

  def run
    @fog_file = {}
    @rows.each do |row|
      fog_key = row[@key].to_sym
      credentials = @fog_file[fog_key] = {}
      @mappings.each do |fog, csv|
        credentials[fog.to_sym] = row[csv]
      end
    end
  end
end
