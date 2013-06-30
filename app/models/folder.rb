class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions, :dependent => :nullify
  has_many :feeds, :through => :subscriptions
end
