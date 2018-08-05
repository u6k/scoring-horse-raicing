class RaceListPage
  extend ActiveSupport::Concern

  attr_reader :url, :date, :course_name

  def initialize(url, date, course_name)
    @url = url
    @date = date
    @course_name = course_name
  end

  def exists?
    false
  end

  def valid?
    false
  end

end
