# Load the rails application.
require File.expand_path('../application', __FILE__)

# Initialize the rails application.
RssReader::Application.initialize!
RssReader::Application.configure do
  config.assets.paths << Rails.root.join("app", "assets", "fonts")
  config.assets.paths << Compass::Frameworks['compass'].stylesheets_directory
  config.assets.precompile += %w( .svg .eot .woff .ttf )
end
