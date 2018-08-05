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

  def same?(obj)
    if not obj.instance_of?(RaceListPage)
      return false
    end

    if self.url != obj.url \
      || self.date != obj.date \
      || self.course_name != obj.course_name
      return false
    end

    true
  end

end
