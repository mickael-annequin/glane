require "test_helper"

class SignInTest < ActionDispatch::IntegrationTest
  test "every page asks to sign in first" do
    get root_path

    assert_redirected_to new_user_session_path
  end

  test "signs in and stays remembered" do
    post user_session_path, params: { user: { email: "marie@glane.test", password: "password", remember_me: "1" } }

    assert_redirected_to root_path
    assert cookies[:remember_user_token].present?
    follow_redirect!
    assert_select ".home-organization", "Secours Populaire Chartres"
  end

  test "refuses a wrong password, in French" do
    post user_session_path, params: { user: { email: "marie@glane.test", password: "wrong" } }

    assert_response :unprocessable_content
    assert_select ".alert", "Email ou mot de passe incorrect."
  end

  test "refuses a deactivated person" do
    post user_session_path, params: { user: { email: "former@glane.test", password: "password" } }
    follow_redirect!

    assert_select ".alert", /Ce compte a été désactivé/
  end

  test "offers no way to create an account" do
    get new_user_session_path

    assert_select "a", text: /inscri/i, count: 0
    assert_not Rails.application.routes.url_helpers.respond_to?(:new_user_registration_path)
  end

  test "signs out" do
    sign_in users(:marie)
    delete destroy_user_session_path
    follow_redirect!

    assert_select ".alert", "Déconnexion réussie."
    get root_path
    assert_redirected_to new_user_session_path
  end
end
