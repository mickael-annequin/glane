require "test_helper"

# Marie is a manager in Chartres, Sophie a member in Chartres, Paul a member in Dreux.
class UserPolicyTest < ActiveSupport::TestCase
  def policy(user, person)
    UserPolicy.new(users(user), users(person))
  end

  test "only managers manage the members" do
    assert UserPolicy.new(users(:marie), User).index?
    assert_not UserPolicy.new(users(:sophie), User).index?
    assert_not UserPolicy.new(users(:admin), User).create?
  end

  test "a manager acts on the people of their structure, but not on themself" do
    assert policy(:marie, :sophie).promote?
    assert policy(:marie, :former_member).reactivate?
    assert_not policy(:marie, :marie).demote?
    assert_not policy(:marie, :marie).deactivate?
    assert_not policy(:marie, :paul).deactivate?
    assert_not policy(:sophie, :marie).demote?
  end
end
