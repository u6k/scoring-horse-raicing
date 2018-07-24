class RefundListPage < ApplicationRecord

  belongs_to :race_list_page

  def self.download(race_list_page, url)
    race_list_page.build_refund_list_page # TODO
  end

end
