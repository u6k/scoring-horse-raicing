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
end

module ScoringHorseRacing::SpecUtil
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
