require 'roda'

module IssPay
  
  class App < Roda
    
    plugin :environments

    configure do
      require 'sequel'

      DB = Sequel.connect("sqlite://db/iss_pay.db")
      def self.db
        DB
      end
    end
  end
end