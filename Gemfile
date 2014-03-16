source 'https://rubygems.org'

gemspec

gem 'rails'
gem 'mongoid'

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => [:jruby]
  gem 'sqlite3', '1.3.8', :platforms => [:ruby, :mswin, :mingw]
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
  gem 'rubysl-test-unit'
  gem 'rubinius-developer_tools'
end
