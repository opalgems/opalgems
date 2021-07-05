module Opalgems
  class Gem
    @@initializers = {}
    attr_accessor :name, :source, :ref
    def initialize(name, source, ref=nil, **kwargs, &block)
      @name, @source, @ref = name, source, ref || "master"
      @@initializers.each do |k,v|
        self.instance_variable_set(:"@#{k}", v.dup)
      end
      Builder.new(self, **kwargs, &block)
    end

    class Builder
      def initialize(gem, **kwargs, &block)
        @gem = gem
        kwargs.each do |k,v|
          public_send(k, v)
        end
        self.instance_exec(&block) if block_given?
      end

      def self.add_builder(name, array: false, hash: false)
        define_method(name) do |arg1=nil, arg2=nil, &block|
          val = @gem.public_send(:"#{name}")
          if array
            val ||= []
            if block && arg1.nil? && arg2.nil?
              val << block
            elsif !block && !arg1.nil? && arg2.nil?
              val << arg1
            else
              raise ArgumentError
            end
          elsif hash
            val ||= {}
            if block && !arg1.nil? && arg2.nil?
              val[arg1] = block
            elsif !block && !arg1.nil? && !arg2.nil?
              val[arg1] = arg2
            else
              raise ArgumentError
            end
          else
            if block && arg1.nil? && arg2.nil?
              val = block
            elsif !block && !arg1.nil? && arg2.nil?
              val = arg1
            else
              raise ArgumentError
            end
          end
          @gem.public_send(:"#{name}=", val)
        end
      end
    end

    def self.add_property(name, array: false, hash: false, default: nil)
      attr_accessor name
      Builder.add_builder name, array: array, hash: hash
      if array
        @@initializers[name] = default || []
      elsif hash
        @@initializers[name] = default || {}
      else
        @@initializers[name] = default
      end
    end

    add_property :tests_only, default: false
    add_property :test_filters, hash: true

    def run_tests?
      !%i[stdlib missing].include?(source)
    end

    def load_path
      if !tests_only && !%i[stdlib missing].include?(source)
        File.expand_path("../../../gems/#{@name}/lib", __FILE__)
      end
    end
  end
end