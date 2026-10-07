require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:marie) }

  test "lists the people of my structure only" do
    get members_path

    assert_response :success
    assert_select "strong", "Sophie Leroy"
    assert_select "strong", "Luc Bernard"
    assert_select "strong", text: "Paul Martin", count: 0
    assert_select ".member-row:first-child strong", "Marie Dupont"
    assert_select ".member-row:last-child strong", "Luc Bernard"
  end

  test "only managers can manage the members" do
    sign_in users(:sophie)
    get members_path

    assert_redirected_to root_path
    assert_equal "Seuls les responsables peuvent gérer les membres.", flash[:alert]
  end

  test "invites a new member in my structure" do
    assert_emails 1 do
      post members_path, params: { email: "Nouveau@Glane.test" }
    end

    assert_redirected_to members_path
    newcomer = User.find_by!(email: "nouveau@glane.test")
    assert newcomer.member?
    assert_equal organizations(:secours_chartres), newcomer.organization
    assert_equal users(:marie), newcomer.invited_by
  end

  test "refuses an email that already has an account, or isn't valid" do
    assert_no_emails do
      post members_path, params: { email: "paul@glane.test" }
      post members_path, params: { email: "pas-un-email" }
    end
    assert_equal "Cet email n'est pas valide.", flash[:alert]
  end

  test "names a manager, then removes the role" do
    patch promote_member_path(users(:sophie))
    assert users(:sophie).reload.manager?

    patch demote_member_path(users(:sophie))
    assert users(:sophie).reload.member?
  end

  test "a deactivated member is signed out at the next page" do
    sophie = users(:sophie)
    patch deactivate_member_path(sophie)
    assert sophie.reload.deactivated_at.present?

    sign_in sophie
    get root_path
    assert_redirected_to new_user_session_path
  end

  test "reactivates a member" do
    patch reactivate_member_path(users(:former_member))

    assert users(:former_member).reload.active_for_authentication?
  end

  test "can't act on myself, so the structure always keeps a manager" do
    patch demote_member_path(users(:marie))
    patch deactivate_member_path(users(:marie))

    assert users(:marie).reload.manager?
    assert_nil users(:marie).deactivated_at
  end

  test "can't touch the people of another structure" do
    patch deactivate_member_path(users(:paul))

    assert_redirected_to root_path
    assert_nil users(:paul).reload.deactivated_at
  end

  test "sends a pending invitation again" do
    pending = User.invite!({ email: "attente@glane.test", organization: organizations(:secours_chartres) }, users(:marie))

    assert_emails 1 do
      post resend_invitation_member_path(pending)
    end
  end

  test "the Ma structure page links to the members, for managers" do
    get organization_path
    assert_select "a[href=?]", members_path, text: /Membres \(2\)/

    sign_in users(:sophie)
    get organization_path
    assert_select "a[href=?]", members_path, count: 0
  end
end
