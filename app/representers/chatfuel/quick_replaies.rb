module ChatFuel

  class QuickReplaies

    def initialize(replies)
      @replies = replies
    end

    def to_json
      @replies.map do |reply|
        {
          title: reply[:title],
          set_attributes: {
            feedbacl: reply[:feedback]
          }
        }
      end
    end
  end
end