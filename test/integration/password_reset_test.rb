require "test_helper"

class PasswordResetTest < ActionDispatch::IntegrationTest
  test "sends a link by email, then the person chooses a new password" do
    get new_user_session_path
    assert_select "a[href=?]", new_user_password_path

    assert_emails 1 do
      post user_password_path, params: { user: { email: "marie@glane.test" } }
    end
    email = ActionMailer::Base.deliveries.last
    assert_equal [ "marie@glane.test" ], email.to
    assert_equal "Glane : choisir un nouveau mot de passe", email.subject

    token = email.text_part.body.to_s[/reset_password_token=([^\s"]+)/, 1]
    get edit_user_password_path(reset_password_token: token)
    assert_response :success

    put user_password_path, params: { user: { reset_password_token: token, password: "nouveau-mdp", password_confirmation: "nouveau-mdp" } }
    assert_redirected_to root_path
    assert users(:marie).reload.valid_password?("nouveau-mdp")
  end

  test "gives the same answer for an unknown email, and sends nothing" do
    assert_no_emails do
      post user_password_path, params: { user: { email: "nobody@glane.test" } }
    end
    follow_redirect!

    assert_select ".alert", /Si cet email correspond à un compte Glane/
  end
end
