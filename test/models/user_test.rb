require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is a member by default" do
    assert User.new.member?
  end

  test "needs a name and a structure" do
    user = User.new(email: "new@glane.test", password: "password")

    assert_not user.valid?
    assert_includes user.errors[:name], "doit être rempli(e)"
    assert_includes user.errors[:organization], "doit être rempli(e)"
  end

  test "the admin doesn't need a structure" do
    user = User.new(email: "boss@glane.test", password: "password", name: "Boss", admin: true)

    assert user.valid?
  end

  test "can sign in while the person and the structure are active" do
    assert users(:marie).active_for_authentication?
    assert users(:admin).active_for_authentication?
  end

  test "can't sign in once deactivated" do
    assert_not users(:former_member).active_for_authentication?
  end

  test "can't sign in when the structure is deactivated" do
    assert_not users(:closed_member).active_for_authentication?
  end
end
