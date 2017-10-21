source 'https://rubygems.org'
ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'webpacker', '~> 3.0'
gem 'activerecord-sqlserver-adapter'
gem 'tiny_tds', '1.3.0' # support for activerecord-sqlserver-adapter on OSX/*NIX
gem 'puma', '~> 3.10'
gem 'haml-rails', '~> 1.0'
gem 'sass-rails', '~> 5.0'
gem 'bourbon', '5.0.0.beta.8'
gem 'neat', '2.1.0'
gem 'uglifier', '>= 1.3.0' # JS asset compression
gem 'jbuilder', '~> 2.5'
gem 'fiscali' # 'quarter' date calculations
gem "intercom-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.7'
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd', require: false # run with `bundle exec erd` to get a pdf chart of the DB schema
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
