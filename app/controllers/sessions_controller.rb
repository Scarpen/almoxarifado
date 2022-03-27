class SessionsController < ApplicationController
  
  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by(username: params[:user][:username])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:notice]="Login Realizado com Sucesso."
      redirect_to root_path
    else
      flash[:notice]="Usuário ou Senha incorreto."
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice]="Deslogado com sucesso"
    redirect_to login_path
  end

end
