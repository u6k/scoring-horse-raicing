require 'test_helper'

class CourseListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download course list page" do
    # precondition
    year = 2018
    month = 7
    day = 16

    # execute 1
    course_list_page = CourseListPage.download(year, month, day)

    # postcondition 1
    assert_nil course_list_page.id
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), course_list_page.date
    assert course_list_page.content.length > 0
    assert course_list_page.valid?

    assert_equal 0, CourseListPage.all.length

    assert_not @bucket.object("course_list/course_list.20180716.html").exists?

    # execute 2
    course_list_page.save!

    # postcondition 2
    assert_equal 1, CourseListPage.all.length

    course_list_page_db = CourseListPage.all[0]
    assert course_list_page.same?(course_list_page_db)
    assert_not_nil course_list_page.id

    assert @bucket.object("course_list/course_list.20180716.html").exists?

    # execute 3
    course_list_page_2 = CourseListPage.download(year, month, day)

    # postcondition 3
    assert_not_nil course_list_page_2.id
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), course_list_page_2.date
    assert course_list_page_2.content.length > 0
    assert course_list_page_2.valid?

    assert_equal 1, CourseListPage.all.length

    # execute 4
    course_list_page_2.save!

    # postcondition 4
    assert_equal 1, CourseListPage.all.length
  end

  test "download course list page: invalid html" do
    # precondition
    year = 1900
    month = 1
    day = 1

    # execute 1
    course_list_page = CourseListPage.download(year, month, day)

    # postcondition 1
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), course_list_page.date
    assert course_list_page.content.length > 0
    assert course_list_page.invalid?
    assert_equal "Invalid html", course_list_page.errors[:date][0]

    assert_equal 0, CourseListPage.all.length

    assert_not @bucket.object("course_list/course_list.20180716.html").exists?

    # execute 2
    assert_raise ActiveRecord::RecordInvalid, "Date Invalid html" do
      course_list_page.save!
    end

    # postcondition 2
    assert_equal 0, CourseListPage.all.length

    assert_not @bucket.object("course_list/course_list.20180716.html").exists?
  end

  test "find all" do
    # precondition
    html1 = File.open("test/fixtures/files/course_list/course_list.20180714.html").read
    html2 = File.open("test/fixtures/files/course_list/course_list.20180715.html").read
    html3 = File.open("test/fixtures/files/course_list/course_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180716.html", html3)

    CourseListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0), url: "http://example.com/course_list.20180714.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0), url: "http://example.com/course_list.20180715.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0), url: "http://example.com/course_list.20180716.html")

    # execute
    course_list_pages = CourseListPage.all.order(:date)

    # postcondition
    assert_equal 3, course_list_pages.length

    course_list_page = course_list_pages[0]
    assert_equal Time.zone.local(2018, 7, 14, 0, 0, 0), course_list_page.date
    assert_equal Digest::MD5.hexdigest(html1), Digest::MD5.hexdigest(course_list_page.content)

    course_list_page = course_list_pages[1]
    assert_equal Time.zone.local(2018, 7, 15, 0, 0, 0), course_list_page.date
    assert_equal Digest::MD5.hexdigest(html2), Digest::MD5.hexdigest(course_list_page.content)

    course_list_page = course_list_pages[2]
    assert_equal Time.zone.local(2018, 7, 16, 0, 0, 0), course_list_page.date
    assert_equal Digest::MD5.hexdigest(html3), Digest::MD5.hexdigest(course_list_page.content)
  end

  test "find by date" do
    # precondition
    html1 = File.open("test/fixtures/files/course_list/course_list.20180714.html").read
    html2 = File.open("test/fixtures/files/course_list/course_list.20180715.html").read
    html3 = File.open("test/fixtures/files/course_list/course_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180716.html", html3)

    CourseListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0), url: "http://example.com/course_list.20180714.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0), url: "http://example.com/course_list.20180715.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0), url: "http://example.com/course_list.20180716.html")

    # execute
    course_list_page = CourseListPage.find_by_date(2018, 7, 15)

    # postcondition
    assert_equal Time.zone.local(2018, 7, 15, 0, 0, 0), course_list_page.date
    assert_equal Digest::MD5.hexdigest(html2), Digest::MD5.hexdigest(course_list_page.content)
  end

  test "find by date: not found" do
    # precondition
    html1 = File.open("test/fixtures/files/course_list/course_list.20180714.html").read
    html2 = File.open("test/fixtures/files/course_list/course_list.20180715.html").read
    html3 = File.open("test/fixtures/files/course_list/course_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180716.html", html3)

    CourseListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0), url: "http://example.com/course_list.20180714.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0), url: "http://example.com/course_list.20180715.html")
    CourseListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0), url: "http://example.com/course_list.20180716.html")

    # execute
    course_list_page = CourseListPage.find_by_date(1900, 1, 1)

    # postcondition
    assert_nil course_list_page
  end

  test "parse race page" do
    # precondition
    html3 = File.open("test/fixtures/files/course_list/course_list.20180716.html").read
    NetModule.put_s3_object(NetModule.get_s3_bucket, "course_list/course_list.20180716.html", html3)
    course_list_page = CourseListPage.new(date: Time.zone.local(2018, 7, 16, 0, 0, 0), url: "http://example.com/course_list.20180716.html")

    # execute
    race_list_pages = course_list_page.download_race_list_pages

    # postcondition
    assert_equal 5, race_list_pages.length

    p race_list_pages.inspect # TODO

    race_list_page = race_list_pages[0]
    assert_equal "帯広競馬場", race_list_page.course_name
    assert_equal "ナイター", race_list_page.timezone
    assert race_list_page.content.length > 0
    assert race_list_page.course_list_page.same?(course_list_page)
    assert race_list_page.valid?
    assert_not @bucket.object("race_list/20180716/race_list.帯広競馬場.html").exists?

    race_list_page = race_list_pages[1]
    assert_equal "盛岡競馬場", race_list_page.course_name
    assert_equal "薄暮", race_list_page.timezone
    assert race_list_page.content.length > 0
    assert race_list_page.course_list_page.same?(course_list_page)
    assert race_list_page.valid?
    assert_not @bucket.object("race_list/20180716/race_list.盛岡競馬場.html").exists?

    race_list_page = race_list_pages[2]
    assert_equal "金沢競馬場", race_list_page.course_name
    assert_equal "薄暮", race_list_page.timezone
    assert race_list_page.content.length > 0
    assert race_list_page.course_list_page.same?(course_list_page)
    assert race_list_page.valid?
    assert_not @bucket.object("race_list/20180716/race_list.金沢競馬場.html").exists?

    race_list_page = race_list_pages[3]
    assert_equal "高知競馬場", race_list_page.course_name
    assert_equal "ナイター", race_list_page.timezone
    assert race_list_page.content.length > 0
    assert race_list_page.course_list_page.same?(course_list_page)
    assert race_list_page.valid?
    assert_not @bucket.object("race_list/20180716/race_list.高知競馬場.html").exists?

    race_list_page = race_list_pages[4]
    assert_equal "佐賀競馬場", race_list_page.course_name
    assert_equal "薄暮", race_list_page.timezone
    assert race_list_page.content.length > 0
    assert race_list_page.course_list_page.same?(course_list_page)
    assert race_list_page.valid?
    assert_not @bucket.object("race_list/20180716/race_list.佐賀競馬場.html").exists?

    assert_equal 0, RaceListPage.all.length
  end

end
