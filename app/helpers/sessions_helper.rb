module SessionsHelper
	#logs in the given user
	def log_in(user)
		session[:user_id] = user.id
	end

	# returns current user
	def current_user

		if session[:user_id]			
			if @current_user
				@current_user
			else
				@current_user = User.find_by(id: session[:user_id])
			end
		elsif cookies.signed[:user_id]
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end	
		end		
		# @current_user ||= User.find_by(id: session[:user_id])
	end

	# remembers a user in a permanent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	#checks if user is logged in
	def logged_in?
		!current_user.nil?
	end

	# logs out then deletes token and cookie
	def log_out
		forget(User.find_by(id: session[:user_id]))
		session.delete(:user_id)
		current_user = nil
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end


end
