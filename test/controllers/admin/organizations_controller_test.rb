require "test_helper"

class Admin::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in users(:admin) }

  test "only the admin can open the admin space" do
    sign_in users(:marie)
    get admin_organizations_path

    assert_redirected_to root_path
  end

  test "lists the structures" do
    get admin_organizations_path

    assert_response :success
    assert_select "strong", "Secours Populaire Chartres"
    assert_select ".badge", "Désactivée"
  end

  test "creates a structure and invites its first manager" do
    assert_difference "Organization.count", 1 do
      assert_emails 1 do
        post admin_organizations_path, params: { organization: { name: "Épicerie sociale Anet", address: "Rue Diane de Poitiers 28260 Anet",
                                                                 latitude: "48.8566", longitude: "1.4418", city: "Anet", manager_email: "Lea@Anet.test" } }
      end
    end

    assert_redirected_to admin_organizations_path
    manager = User.find_by!(email: "lea@anet.test")
    assert manager.manager?
    assert manager.invitation_pending?
    assert_equal "Épicerie sociale Anet", manager.organization.name
    assert_equal users(:admin), manager.invited_by
  end

  test "asks for the name, the address and the manager email" do
    assert_no_difference "Organization.count" do
      post admin_organizations_path, params: { organization: { name: "", address: "", manager_email: "" } }
    end

    assert_response :unprocessable_content
    assert_select ".alert", /Nom doit être rempli/
    assert_select ".alert", /Email du premier responsable doit être rempli/
  end

  test "refuses a manager email that already has an account" do
    assert_no_difference "Organization.count" do
      post admin_organizations_path, params: { organization: { name: "Autre", address: "Dreux", latitude: "48.73", longitude: "1.37", manager_email: "marie@glane.test" } }
    end

    assert_select ".alert", /a déjà un compte Glane/
  end

  test "edits a structure" do
    patch admin_organization_path(organizations(:restos_dreux)), params: { organization: { phone: "02 37 11 22 33" } }

    assert_redirected_to admin_organizations_path
    assert_equal "02 37 11 22 33", organizations(:restos_dreux).reload.phone
  end

  test "deactivates and reactivates a structure" do
    organization = organizations(:restos_dreux)

    patch deactivate_admin_organization_path(organization)
    assert_not organization.reload.active?
    assert_not users(:paul).active_for_authentication?

    patch reactivate_admin_organization_path(organization)
    assert organization.reload.active?
  end

  test "invites another manager, and sends a pending invitation again" do
    organization = organizations(:restos_dreux)

    assert_emails 1 do
      post admin_organization_manager_invitations_path(organization), params: { email: "nouveau@dreux.test" }
    end
    assert User.find_by!(email: "nouveau@dreux.test").manager?

    assert_emails 1 do
      post admin_organization_manager_invitations_path(organization), params: { email: "nouveau@dreux.test" }
    end
    assert_equal 1, User.where(email: "nouveau@dreux.test").count
  end

  test "doesn't invite someone who already has an account" do
    assert_no_emails do
      post admin_organization_manager_invitations_path(organizations(:restos_dreux)), params: { email: "marie@glane.test" }
    end

    assert_equal "marie@glane.test a déjà un compte Glane.", flash[:alert]
  end
end
