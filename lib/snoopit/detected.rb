module Snoopit
  class Detected

    attr :before, :after, :after_count, :comment, :regexp, :match, :finished

    def initialize(pre_before, after, match)
      setup_before pre_before
      @after_count = 0
      @after       = Register.new(after)
      @match       = match
      @finished      = false
    end

    def setup_before(pre_before)
      @before = Register.new pre_before.size, pre_before
    end

    def track(line)
      if @after_count < @after
        after.push_front line
      else
        @finished = true
      end
    end

    def finished?
      @finished
    end

  end
end