require 'roar/decorator'
require 'roar/json'

module IssPay

  class UserRepresenter < Roar::Decorator
    include Roar::JSON

    property :full_name
  end
end