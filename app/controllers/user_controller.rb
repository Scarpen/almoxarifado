class UserController < ApplicationController
  layout "sessions"
  def create
    user = User.new(user_params)
    if user.save
      flash[:notice]="Cadastro realizado com sucesso"
      redirect_to login_path
    else
      flash[:notice]="Por favor, tente novamente"
      redirect_to signup_path
    end
  end

  def new
    redirect_to root_path if current_user
  end

  private

    def user_params
      params.require(:user).permit( :username, :password)
    end

end
