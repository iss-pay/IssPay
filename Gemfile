source 'https://rubygems.org'
ruby '2.5.1'

#console tool
gem 'pry', '~> 0.11.2'
gem 'rake', '~> 12.3', '>= 12.3.1'

#configuration
gem 'econfig', '~> 2.1'

#data representer
gem 'json', '~> 2.1'
gem 'roar', '~> 1.1'
gem 'multi_json', '~> 1.13', '>= 1.13.1'

#xlsx reader
gem 'simple_xlsx_reader', '~> 1.0', '>= 1.0.4'

#service
gem 'dry-monads', '~> 1.1'
gem 'dry-transaction', '~> 0.13.0'

#application server
gem 'puma', '~> 3.12'

#interface between application server and web server
gem 'rack', '~> 2.0', '>= 2.0.5'
gem 'roda', '~> 3.13'

#database and orm
gem 'sequel', '~> 5.13'
gem 'redis-rack', '~> 2.0', '>= 2.0.4' #nosql for session management
gem 'hirb', '~> 0.7.3' #pretty format for database

#clean html
gem 'slim', '~> 4.0', '>= 4.0.1'

#security
gem 'rbnacl-libsodium', '~> 1.0', '>= 1.0.16'

#http transfer
gem 'http', '~> 4.0'

#Graph for Data Visualization
gem 'chartkick', '~> 1.4', '>= 1.4.1'

group :development, :test do
  gem 'sqlite3', '~> 1.3', '>= 1.3.13'
end

group :production do
  gem 'pg'
end