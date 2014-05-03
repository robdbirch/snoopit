module Snoopit

  # Behaves a bit like a CPU register
  class Register

    attr :size, :register


    # index always points to where the next element will be added
    def initialize(size=10, data=nil)
      if data.nil?
        @register = Array.new size
      else
        @register = Array.new size
        cloned = data.clone
        [0...size].each { |i| @register[i] = cloned[i] }
      end
    end


    # pushes one object to the front of the array and pops one off the end and returns is
    def unshift(object)
      @register.unshift object
      @register.pop
    end

    # pushes one object on to the end of the array and pops one off the front and returns is
    def shift(object)
      @register.push object
      @register.slice! 0
    end

    alias_method :push_front, :unshift
    alias_method :push_back, :shift

    def size
      @register.size
    end

    def length
      @register.length
    end

  end


end