module ChatFuel

  class Attachment
    def initialize(type=nil, payload)
      @type = type || "template"
      @payload = payload
    end

    def to_json
      {
        "attachment":{
          type: @type,
          payload: @payload
        }
      }
    end
  end
end