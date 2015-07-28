#
# Taken from http://pivotallabs.com/users/mgehard/blog/articles/1639-making-sure-you-implement-the-activemodel-interface-fully
#
shared_examples_for "ActiveModel" do
  require 'test/unit/assertions'
  require 'active_model/lint'
  include Test::Unit::Assertions
  include ActiveModel::Lint::Tests

  before do
    @model = subject
  end

  ActiveModel::Lint::Tests.public_instance_methods.map { |method| method.to_s }.grep(/^test/).each do |method|
    RSpec.current_example(method.gsub('_', ' ')) #{ send method }
  end
end
