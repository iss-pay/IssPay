require 'roda'
require 'econfig'

module IssPay
  
  class App < Roda
    
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://" + config.DB_FILENAME
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