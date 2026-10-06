require "test_helper"

class AccountPasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:paul) }

  test "changes the password and stays signed in" do
    patch account_password_path, params: { user: { current_password: "password", password: "nouveau-mdp", password_confirmation: "nouveau-mdp" } }

    assert_redirected_to organization_path
    assert users(:paul).reload.valid_password?("nouveau-mdp")
    get organization_path
    assert_response :success
  end

  test "asks for the right current password" do
    patch account_password_path, params: { user: { current_password: "wrong", password: "nouveau-mdp", password_confirmation: "nouveau-mdp" } }

    assert_response :unprocessable_content
    assert_select ".alert", /Le mot de passe actuel n'est pas valide/
    assert users(:paul).reload.valid_password?("password")
  end
end
