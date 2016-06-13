require 'jwt'
class SessionsController < ApplicationController

	before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :logout]
	before_filter :save_login_state, :only => [:index, :login, :login_attempt]

	def home
		#Home Page
	end

	def profile
		#Profile Page
	end

	def setting
		#Setting Page
	end

	def login
		#Login Form
	end

	def login_attempt
		authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
		if authorized_user
			session[:user_id] = authorized_user.id
			flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
			redirect_to(:action => 'home')


		else
			flash[:notice] = "Invalid Username or Password"
        	flash[:color]= "invalid"
			render "login"
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to :action => 'login'
	end

	def updateuser
		puts "Frontend passed below values:"
		puts "Username: " + params[:username_or_email]
		puts "Relationship: " + params[:user_relationship]
		check_user = User.updaterelationship(params[:username_or_email],params[:user_relationship])
		head 200, content_type: "text/html"
	end

	def generatetoken
		context = params[:context]
		ENV['context'] = context
		puts context
		exp = Time.now.to_i + 8 * 60
		iat = Time.now.to_i
		header = {:typ => 'JOSE', :kid => ENV['APIKEY']}
		payload ={:sub => '1234567890', :name => 'John Doe', :admin => true, :iat => iat, :exp => exp, :context => context}
		ENV['token'] = JWT.encode payload, 'secret', 'HS256', header

    head 200, content_type: "text/html"
  end
end
