module ChatFuel
  class Text
    def initialize(texts)
      @texts = texts
    end

    def to_json
      @texts.map do |text|
        {text: text}
      end
    end
  end
end