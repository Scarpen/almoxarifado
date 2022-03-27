module SessionsHelper

	def logged_in?
    	current_user
    end

   	def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def authorize
      unless logged_in?
        redirect_to login_path
      end
   end

end
