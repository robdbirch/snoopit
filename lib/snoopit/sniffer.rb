module Snoopit

  # Does the actual searching for the given regular expression
  class Sniffer

    attr :pre_before, :before, :after, :comment, :regexp, :sniffed, :notifiers

    # This creates a +Sniffer+ which was specified in the +snoopers.json+ file in the +sniffers+ section
    # @param sniffer_params [Hash] this is a hash from the +snoopers.json+ file in the +sniffers+ section for the assciated +Snoopy+
    def initialize(sniffer_params)
      @before  = sniffer_params['lines']['before'].nil? ? 2 : sniffer_params['lines']['before']
      @pre_before = Register.new @before
      @after   = sniffer_params['lines']['after'].nil? ? 2 : sniffer_params['lines']['after']
      @comment = sniffer_params['comment']
      @regexp  = Regexp.new sniffer_params['regexp']
      @notifiers = {}
      setup_notifiers sniffer_params
      @sniffed = []
    end

    # Set up the specified notifier parameters
    # @param params [Hash] this is a hash from the +snoopers.json+ file in the +notify+ section for the  associated +Sniffer+
    def setup_notifiers(params)
      @notifiers = params['notify'] unless params['notify'].nil?
    end

    # This sniffer tracks through a file until it detects a match
    # @param file [String] file the +sniffer+ is tracking
    # @param line_no [Integer] line number the +sniffer+ is tracking
    # @param  line [String] line the +sniffer+ is tracking
    def track(file, line_no, line)
      matched = @regexp.match(line) do |m|
        @sniffed << Detected.new(@comment, @pre_before, @after, line, file, line_no)
      end
      @pre_before.push_front line if matched.nil?
      tracking line
    end

    # This is tracking the lines after the match
    # The +Detected+ instance will let us know when we are finished collecting lines
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
          regexp: @regexp.to_json,
          sniffed: @sniffed,
          notifiers: @notifiers
      }
    end

    def to_json(*a)
      as_json.to_json(*a)
    end

  end
end