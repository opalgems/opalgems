# The description of the included standard gems

module Opalgems
  GHRuby = Object.new
  def GHRuby./(repo); "https://github.com/ruby/#{repo}"; end

  GHOpalgems = Object.new
  def GHOpalgems./(repo); "https://github.com/opalgems/#{repo}"; end

  add_gem "prime", GHRuby/"prime", "v0.1.2"

  add_gem "matrix", GHRuby/"matrix", "v0.3.1", tests_only: true do
    test_filters(:TestMatrix) do # Sample DSL usage...
      bug :test_encode64
    end
  end

  add_gem "bigdecimal", :stdlib

  add_gem "rubygems", :missing
end