module Snoopit

  # When the sniffer detects a match it saves the contextual information in a +Detected+ instances
  class Detected

    attr :comment, :before, :after, :after_count, :regexp, :match, :finished, :file, :line_no

    # These are parameters from the match
    def initialize(comment, pre_before, after, match, file, line_no)
      setup_before pre_before
      @comment     = comment
      @after_count = 0
      @after       = Register.new(after)
      @match       = match
      @file        = file
      @line_no     = line_no
      @finished    = false
    end

    # Get the lines before the found match
    def setup_before(pre_before)
      @before = Register.new pre_before.size, pre_before.register
    end

    # This collects the lines after a match is found
    def track(line)
      return if line == @match
      if @after_count < @after.size
        @after.push_front line
        @after_count += 1
      else
        @finished = true
      end
    end

    def finished?
      @finished
    end

    def as_json(options=nil)
      {
          after: @after,
          match: @match,
          before: @before,
          file: @file,
          line_no: @line_no
      }
    end

    def to_json(*a)
      as_json.to_json(*a)
    end

  end
end