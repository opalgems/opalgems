require "opalgems/version"
require "opalgems/gem"
require "opalgems/gems"

module Opalgems
  module_function
  
  @gems = Gems.new

  class << self
    attr_reader :gems

    def add_gem(name, *args, **kwargs, &block)
      gems[name] = Gem.new(name, *args, **kwargs, &block)
    end

    def add_to_load_path
      require "opal"
      @gems.values.map(&:load_path).compact.each do |path|
        Opal.append_path(path)
      end
    end

    def prepare_submodules
      require "fileutils"
    end
  end
end

require "opalgems/config"