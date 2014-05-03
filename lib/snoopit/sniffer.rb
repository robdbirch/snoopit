module Snoopit
  class Sniffer

    attr :pre_before, :before, :after, :comment, :regexp, :sniffed

    def initialize(sniffer_params)
      @before  = sniffer_params['lines']['before'].nil? ? 2 : sniffer_params['lines']['before']
      @pre_before = Register.new @before
      @after   = sniffer_params['lines']['after'].nil? ? 2 : sniffer_params['lines']['after']
      @comment = sniffer_params['comment']
      @regexp  = Regexp.new sniffer_params['regexp']
      @sniffed = []
    end

    def track(file, line_no, line)
      matched = @regexp.match(line) do |m|
        @sniffed << Detected.new(@pre_before, @after, line, file, line_no)
      end
      @pre_before.push_front line if matched.nil?
      tracking line
    end

    def tracking(line)
      @sniffed.each do |detected|
        detected.track line unless detected.finished?
      end
    end

    def as_json(options=nil)
      {
          before: @before,
          after: @after,
          comment: @comment,
          regext: @regexp.to_json,
          sniffed: @sniffed
      }
    end

    def to_json(*a)
      as_json.to_json(*a)
    end

  end
end