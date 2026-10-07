# Changes the password of the signed-in person, who must type the current one first.
class AccountPasswordsController < ApplicationController
  skip_after_action :verify_authorized # only the signed-in person's own password
  def edit
  end

  def update
    if current_user.update_with_password(password_params)
      # Changing the password signs the person out of Devise: sign them back in on this device.
      bypass_sign_in(current_user)
      redirect_to organization_path, notice: "Mot de passe changé."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
