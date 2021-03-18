class Api::V1::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params) if params['user']

    if params['user']['role'] === 'town_hall'
      profile = TownHallProfile.new(town_hall_profile_params) if params['town_hall_profile']
    else
      profile = Profile.new(profile_params) if params['profile']
    end
    
    profile.user = user if profile

    if profile && user.save && profile.valid?
      profile.save

      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      },
      include: :profile,
      status: :created
    else
      User.find(user.id).destroy if user.id && User.find(user.id)

      render json: { status: :unprocessable_entity },
        status: :unprocessable_entity,
        message: "Incorrect information"
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name)
    end

    def town_hall_profile_params
      params.require(:town_hall_profile).permit(:name)
    end
end
