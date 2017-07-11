require 'test_helper'

class Discord::NotifierTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Discord::Notifier::VERSION
  end
end
