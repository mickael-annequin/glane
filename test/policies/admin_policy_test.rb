require "test_helper"

class AdminPolicyTest < ActiveSupport::TestCase
  test "only the admin account opens the admin space" do
    assert AdminPolicy.new(users(:admin), :admin).access?
    assert_not AdminPolicy.new(users(:marie), :admin).access?
  end
end
