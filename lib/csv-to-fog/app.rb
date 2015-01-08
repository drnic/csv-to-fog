require "optparse"

class CsvToFog::App
  def self.run(args)
    key = nil
    unparsed_mappings = []
    OptionParser.new do |opts|
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
    app.validate!
    app.run
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

  def validate!
    errors = false
    $stderr.puts "--key is required" unless @key
    $stderr.puts "--map is required" if @mappings.size == 0
    exit 1 if errors
  end

  def run
    p @key, @mappings
  end
end
