class UsersController < ApplicationController
    
	def new 
		@user = User.new
        @role = 'user'
	end

	def create
        @user = User.new(user_params)
        if @user.save
            redirect_to root_url, :notice => "Signed up!"
        else
            render 'new'
        end
    rescue Moped::Errors::OperationFailure  => err
        # check for the appropriate error message indicating a duplicate index

        if err.message =~ /email_index/
            @user.errors.add(:email, "already exists for another account")
        else
            @user.errors.add(:base, err.message)
        end
                            
        render 'new'
	end
    
    def show
        @user = Users.find(params[:id])
    end
    
    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
