class Api::V1::SessionsController < ApplicationController
  include CurrentUserConcern

  def create
    puts '$$$$$$$$$$'
    puts session_params
    puts '$$$$$$$$$$'

    if session_params
      user = User
        .find_by(email: params['user']['email'])
        .try(:authenticate, params['user']['password'])
    end

    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      },
      include: :profile,
      status: :created
    else
      render json: { status: 401 }, status: :unprocessable_entity
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
