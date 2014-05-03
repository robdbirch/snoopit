module Snoopit
  class Sniffer

    attr :pre_before, :before, :after, :comment, :regexp, :sniffing, :sniffed

    def initialize(sniffer_params)
      @before  = sniffer_params['lines']['before'].nil? ? 5 : sniffer_params['lines']['before']
      @pre_before = Register.new @before
      @after   = sniffer_params['lines']['after'].nil? ? 5 : sniffer_params['lines']['after']
      @comment = sniffer_params['comment']
      @regexp  = Regexp.new sniffer_params['regexp']
      @sniffing = []
      @sniffed = []
    end

    def track(line)
      @pre_before.push_front line
      @regexp.match(line) do |m|
        @sniffing << Detected.new(@pre_before, @after, m)
      end
      tracking line
    end

    def tracking(line)
      remove = []
      @sniffing.each do |detected|
        detected.track line
        if detected.finished?
          @sniffed << detected
          remove << detected
        end
      end
      adjust_tracking remove
    end

    def adjust_tracking(remove)
      remove.each do |r|
        @sniffing.delete r
      end
    end

  end
end