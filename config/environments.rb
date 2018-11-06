require 'roda'
require 'econfig'
require 'rack/session/redis'
require 'chartkick'

module IssPay
  
  class App < Roda
    
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    ONE_MONTH = 30*24*60*60

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://" + config.DB_FILENAME

      use Rack::Session::Cookie, expire_after: ONE_MONTH,
          secret: 'some secret'
    end

    configure :production do
      use Rack::Session::Cookie, expire_after: ONE_MONTH,
          secret: 'some secret'
      # use Rack::Session::Redis, expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end

    configure do
      require 'sequel'

      DB = Sequel.connect(ENV['DATABASE_URL'])
      def self.db
        DB
      end
    end
  end
end