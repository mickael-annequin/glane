# "Mon compte": the name, phone and followed categories of the signed-in person.
class AccountsController < ApplicationController
  skip_after_action :verify_authorized # only the signed-in person's own account
  def edit
  end

  def update
    if current_user.update(account_params)
      current_user.follow_only(params[:followed_category_ids])
      redirect_to organization_path, notice: "Compte enregistré."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def account_params
    params.require(:user).permit(:name, :phone)
  end
end
