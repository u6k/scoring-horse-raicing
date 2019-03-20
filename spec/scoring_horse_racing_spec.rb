require "webmock/rspec"

RSpec.describe ScoringHorseRacing do
  it "has a version number" do
    expect(ScoringHorseRacing::VERSION).not_to be nil
  end
end

RSpec.describe ScoringHorseRacing::CLI do
  before do
    WebMock.enable!

    WebMock.stub_request(:get, /https:\/\/keiba\.yahoo\.co\.jp\/.*/).to_return(
      status: [404, "Not Found"])

    WebMock.disable_net_connect!(allow: "s3")
  end

  after do
    WebMock.disable!
  end

  it "help is success" do
    result = capture(:stdout) {
      ScoringHorseRacing::CLI.new.invoke("help")
    }

    expect(result).to eq <<~EOS
      Commands:
        rspec crawl           # Crawl
        rspec help [COMMAND]  # Describe available commands or one specific command
        rspec version         # Display version

    EOS
  end

  it "crawl is success" do
    ScoringHorseRacing::CLI.new.invoke("crawl", [], s3_access_key: ENV["AWS_S3_ACCESS_KEY"], s3_secret_key: ENV["AWS_S3_SECRET_KEY"], s3_region: ENV["AWS_S3_REGION"], s3_bucket: ENV["AWS_S3_BUCKET"], s3_endpoint: ENV["AWS_S3_ENDPOINT"], s3_force_path_style: ENV["AWS_S3_FORCE_PATH_STYLE"], interval: 0.001)
  end
end

