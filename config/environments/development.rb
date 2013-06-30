RssReader::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = true
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    #  Bullet.growl = true
    Bullet.rails_logger = true
  end
end
class ActiveRecord::Base
  # Usage:
  #
  #     > puts User.first.to_factory_girl
  #     FactoryGirl.define do
  #       factory :user do
  #         ...
  #       end
  #     end
  def to_factory_girl
    ignores = %w(id created_at updated_at)
    array = []
    array << "FactoryGirl.define do"
    array << "  factory :#{self.class.model_name.to_s.underscore} do"
    attributes.each do |key, value|
      next if ignores.include?(key)
      if key =~ /_id$/
        array << "    association :#{key.gsub(/_id$/, '')}"
      else
        array << "    #{key} #{value.inspect}"
      end
    end
    array << "  end"
    array << "end"
    array.join("\n")
  end
  alias_method :to_fg, :to_factory_girl
end
