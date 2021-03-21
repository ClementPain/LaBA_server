class Api::V1::SessionsController < ApplicationController
  include CurrentUserConcern

  def create
    if session_params
      if user = User.find_by(email: params['user']['email'])
        if user = user.try(:authenticate, params['user']['password'])
          session[:user_id] = user.id
          render json: {
            status: :created,
            logged_in: true,
            user: user
          },
          include: :profile,
          status: :created
        else
          error_authentification = "Mot de passe incorrect"
        end
      else
        error_authentification = "Cet email ne correspond à aucun utilisateur"
      end
      
      if error_authentification
        render json: { error_message: error_authentification, status: :unprocessable_entity }, status: :unprocessable_entity
      end
    else
      render json: { error_message: session_params.errors }, status: :unprocessable_entity
    end
  end

  def logged_in
    if @current_user
      render json: {
        logged_in: true,
        user: @current_user
      },
      status: 200
    else
      render json: {
        logged_in: false
      },
      status: 200
    end
  end

  def logout
    reset_session
    render json: {
      status: 200,
      logout: true
    },
    status: 200
  end

  private

  def session_params
    params.require(:user).permit(:email, :password, :role)
  end
end
