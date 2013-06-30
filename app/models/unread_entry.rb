class UnreadEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription
  belongs_to :entry


end
