module Snoopit
  class Sniffer

    attr :pre_before, :before, :after, :comment, :regexp, :sniffed

    def initialize(sniffer_params)
      @before  = sniffer_params['lines']['before'].nil? ? 5 : sniffer_params['lines']['before']
      @pre_before = Register.new @before
      @after   = sniffer_params['lines']['after'].nil? ? 5 : sniffer_params['lines']['after']
      @comment = sniffer_params['comment']
      @regexp  = Regexp.new sniffer_params['regexp']
      @sniffed = []
    end

    def track(file, line_no, line)
      @pre_before.push_front line
      @regexp.match(line) do |m|
        @sniffed << Detected.new(@pre_before, @after, m, file, line_no)
      end
      tracking line
    end

    def tracking(line)
      @sniffed.each do |detected|
        detected.track line
      end
    end

  end
end