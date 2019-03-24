module ChatFuel

  class Message
    def initialize(texts: nil, attachments: nil, quick_replies: nil)
      @texts = texts
      @attachments = attachments
      @quick_replies = quick_replies
    end

    def to_json
      messages = []
      messages = @texts.to_json unless @texts.nil?
      messages.push(@attachments.to_json) unless @attachments.nil?
      messages.push(@quick_replies.to_json) unless @quick_replies.nil?
      {
        messages: messages
      }
    end
  end
end