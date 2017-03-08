class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :active_trips]
  skip_before_action :authenticate_request, only: [:create]

  # GET /users
  def index
    @users = User.all
    #render json: @users    # this works but not in format Malik wants
    render json: "{\"users\":" + @users.to_json + "}" # Malik's request (but unserialized)
    # but we don't actually need an index at all
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # GET /users/1/active_trips
  def active_trips
    @active_trips = []
    @user.pools.where(:is_active => true).each { |pool| @active_trips << Trip.find(pool.trip_id)}
    render json: @active_trips
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:password, :password_confirmation,
        :first_name, :last_name, :has_avatar, :email, :phone, 
        :gender, :company, :position, :driving_pref, :car, 
        :radio_stations, :talkativeness, :smoke, :ac)
    end
end
