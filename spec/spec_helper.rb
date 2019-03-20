require "bundler/setup"
require "scoring_horse_racing"
require "crawline"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Captures the output for analysis later
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

module ScoringHorseRacing::SpecUtil
  def self.build_downloader
    Crawline::Downloader.new("scoring-horse-racing/#{ScoringHorseRacing::VERSION} (https://github.com/u6k/scoring-horse-racing)")
  end

  def self.build_resource_repository
    access_key = ENV["AWS_S3_ACCESS_KEY"]
    secret_key = ENV["AWS_S3_SECRET_KEY"]
    region = ENV["AWS_S3_REGION"]
    bucket = ENV["AWS_S3_BUCKET"]
    endpoint = ENV["AWS_S3_ENDPOINT"]
    force_path_style = ENV["AWS_S3_FORCE_PATH_STYLE"]

    # Setup ResourceRepository
    repo = Crawline::ResourceRepository.new(access_key, secret_key, region, bucket, endpoint, force_path_style)
  end
end
