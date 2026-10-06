require "test_helper"

class InvitationTest < ActionDispatch::IntegrationTest
  test "an invited person chooses their name and password, then is signed in" do
    assert_emails 1 do
      User.invite!({ email: "julie@glane.test", organization: organizations(:restos_dreux), role: :manager }, users(:admin))
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal "Invitation à rejoindre Glane", email.subject
    assert_match "Admin Glane vous invite à rejoindre Restos du Cœur Dreux", email.text_part.body.to_s

    token = email.text_part.body.to_s[/invitation_token=([^\s"]+)/, 1]
    get accept_user_invitation_path(invitation_token: token)
    assert_response :success
    assert_select "strong", "Restos du Cœur Dreux"

    put user_invitation_path, params: { user: { invitation_token: token, name: "Julie Petit", phone: "06 00 00 00 00",
                                                password: "mot-de-passe", password_confirmation: "mot-de-passe" } }
    assert_redirected_to root_path

    julie = User.find_by!(email: "julie@glane.test")
    assert_equal "Julie Petit", julie.name
    assert julie.manager?
    assert julie.invitation_accepted?
  end

  test "the name is required to accept" do
    user = User.invite!({ email: "julie@glane.test", organization: organizations(:restos_dreux) }, users(:admin))

    put user_invitation_path, params: { user: { invitation_token: user.raw_invitation_token, name: "",
                                                password: "mot-de-passe", password_confirmation: "mot-de-passe" } }

    assert_response :unprocessable_content
    assert_select ".alert", /Prénom et nom doit être rempli/
  end

  test "a pending invitation can't be used to sign in" do
    User.invite!({ email: "julie@glane.test", organization: organizations(:restos_dreux) }, users(:admin))

    post user_session_path, params: { user: { email: "julie@glane.test", password: "anything" } }

    assert_response :unprocessable_content
  end

  test "a wrong invitation link is refused, with an explanation" do
    get accept_user_invitation_path(invitation_token: "wrong")
    follow_redirect!

    assert_select ".alert", /Ce lien d'invitation n'est pas valable/
  end

  test "there is no page to invite anyone" do
    sign_in users(:paul)

    assert_not Rails.application.routes.url_helpers.respond_to?(:new_user_invitation_path)
  end
end
