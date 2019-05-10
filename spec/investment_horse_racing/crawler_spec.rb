require "webmock/rspec"

RSpec.describe InvestmentHorseRacing::Crawler do
  it "has a version number" do
    expect(InvestmentHorseRacing::Crawler::VERSION).not_to be nil
  end
end

RSpec.describe InvestmentHorseRacing::Crawler::CLI do
  before do
    # Setup webmock
    WebMock.enable!

    WebMock.stub_request(:get, /https:\/\/keiba\.yahoo\.co\.jp\/.*/).to_return(
      status: [404, "Not Found"])

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/schedule/list/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/schedule.201806.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/schedule/list/2018/?month=06").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/schedule.201806.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/list/18020104/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/race_list.20180624.hakodate.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/list/18090308/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/race_list.20180624.hanshin.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/list/18050308/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/race_list.20180624.tokyo.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/result/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/result/1805030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20180624.tokyo.10.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/race/denma/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/entry.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015100586/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015100586.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015100632/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015100632.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015101618/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015101618.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015102694/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015102694.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015102837/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015102837.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015102853/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015102853.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015103335/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015103335.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015103462/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015103462.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015103557/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015103557.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015103590/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015103590.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015104308/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015104308.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015104928/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015104928.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015104964/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015104964.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015104979/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015104979.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015105363/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015105363.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/horse/2015106259/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015106259.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/00894/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.00894.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01014/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01014.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01018/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01018.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01019/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01019.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01034/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01034.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01088/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01088.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01114/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01114.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01116/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01116.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01126/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01126.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01130/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01130.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01154/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01154.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01165/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01165.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/01166/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.01166.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/05203/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.05203.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/05339/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.05339.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/jocky/05386/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/jockey.05386.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/00356/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.00356.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/00438/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.00438.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01022/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01022.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01041/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01041.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01046/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01046.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01050/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01050.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01066/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01066.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01073/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01073.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01078/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01078.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01104/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01104.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01111/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01111.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01120/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01120.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01138/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01138.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01140/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01140.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/directory/trainer/01157/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01157.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/tfw/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_win.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/ur/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_quinella.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/wide/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_quinella_place.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/ut/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_exacta.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/sf/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_trio.20180624.hanshin.1.html").read)

    WebMock.stub_request(:get, "https://keiba.yahoo.co.jp/odds/st/1809030801/").to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read)

    WebMock.disable_net_connect!(allow: "s3")

    # Setup data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all

    # Setup resource repository
    @repo = Crawline::ResourceRepository.new(ENV["AWS_S3_ACCESS_KEY"], ENV["AWS_S3_SECRET_KEY"], ENV["AWS_S3_REGION"], ENV["AWS_S3_BUCKET"], ENV["AWS_S3_ENDPOINT"], ENV["AWS_S3_FORCE_PATH_STYLE"], nil)
    @repo.remove_s3_objects
  end

  after do
    WebMock.disable!
  end

  it "is version" do
    stdout = capture(:stdout) { InvestmentHorseRacing::Crawler::CLI.new.invoke("version") }

    expect(stdout).to eq "#{InvestmentHorseRacing::Crawler::VERSION}\n"
  end

  it "crawl is success" do
    expect(count_s3_objects).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to eq 0

    InvestmentHorseRacing::Crawler::CLI.new.invoke(
      "crawl", [],
      s3_access_key: ENV["AWS_S3_ACCESS_KEY"],
      s3_secret_key: ENV["AWS_S3_SECRET_KEY"],
      s3_region: ENV["AWS_S3_REGION"],
      s3_bucket: ENV["AWS_S3_BUCKET"],
      s3_endpoint: ENV["AWS_S3_ENDPOINT"],
      s3_force_path_style: ENV["AWS_S3_FORCE_PATH_STYLE"],
      interval: 0.001,
      db_database: ENV["DB_DATABASE"],
      db_host: ENV["DB_HOST"],
      db_port: ENV["DB_PORT"],
      db_username: ENV["DB_USERNAME"],
      db_password: ENV["DB_PASSWORD"],
      db_sslmode: ENV["DB_SSLMODE"])

    expect(count_s3_objects).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to be > 0
  end

  it "crawl (specify entrypoint_url) is success" do
    InvestmentHorseRacing::Crawler::CLI.new.invoke(
      "crawl", [],
      s3_access_key: ENV["AWS_S3_ACCESS_KEY"],
      s3_secret_key: ENV["AWS_S3_SECRET_KEY"],
      s3_region: ENV["AWS_S3_REGION"],
      s3_bucket: ENV["AWS_S3_BUCKET"],
      s3_endpoint: ENV["AWS_S3_ENDPOINT"],
      s3_force_path_style: ENV["AWS_S3_FORCE_PATH_STYLE"],
      interval: 0.001,
      db_database: ENV["DB_DATABASE"],
      db_host: ENV["DB_HOST"],
      db_port: ENV["DB_PORT"],
      db_username: ENV["DB_USERNAME"],
      db_password: ENV["DB_PASSWORD"],
      db_sslmode: ENV["DB_SSLMODE"],
      entrypoint_url: "https://keiba.yahoo.co.jp/directory/trainer/01140/")

    expect(count_s3_objects).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to eq 0
  end

  it "parse is success" do
    expect(count_s3_objects).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to eq 0

    InvestmentHorseRacing::Crawler::CLI.new.invoke(
      "crawl", [],
      s3_access_key: ENV["AWS_S3_ACCESS_KEY"],
      s3_secret_key: ENV["AWS_S3_SECRET_KEY"],
      s3_region: ENV["AWS_S3_REGION"],
      s3_bucket: ENV["AWS_S3_BUCKET"],
      s3_endpoint: ENV["AWS_S3_ENDPOINT"],
      s3_force_path_style: ENV["AWS_S3_FORCE_PATH_STYLE"],
      interval: 0.001,
      db_database: ENV["DB_DATABASE"],
      db_host: ENV["DB_HOST"],
      db_port: ENV["DB_PORT"],
      db_username: ENV["DB_USERNAME"],
      db_password: ENV["DB_PASSWORD"],
      db_sslmode: ENV["DB_SSLMODE"])

    expect(count_s3_objects).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to be > 0

    InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all

    expect(count_s3_objects).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to eq 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to eq 0

    InvestmentHorseRacing::Crawler::CLI.new.invoke(
      "parse", [],
      s3_access_key: ENV["AWS_S3_ACCESS_KEY"],
      s3_secret_key: ENV["AWS_S3_SECRET_KEY"],
      s3_region: ENV["AWS_S3_REGION"],
      s3_bucket: ENV["AWS_S3_BUCKET"],
      s3_endpoint: ENV["AWS_S3_ENDPOINT"],
      s3_force_path_style: ENV["AWS_S3_FORCE_PATH_STYLE"],
      db_database: ENV["DB_DATABASE"],
      db_host: ENV["DB_HOST"],
      db_port: ENV["DB_PORT"],
      db_username: ENV["DB_USERNAME"],
      db_password: ENV["DB_PASSWORD"],
      db_sslmode: ENV["DB_SSLMODE"])

    expect(count_s3_objects).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceScore.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to be > 0
    expect(InvestmentHorseRacing::Crawler::Model::OddsTrio.count).to be > 0
  end

  def count_s3_objects
    count = 0

    @repo.list_s3_objects { count += 1 }

    count
  end
end
