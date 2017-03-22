class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :active_trips, :active_copoolers]
  before_action :confirm_correct_user, only: [:update, :destroy]
  skip_before_action :authenticate_request, only: [:create]

  # GET /users    <-- not necessary
  def index
    @users = User.all
    render json: {users: UserSerializer.new(@users)}    # I think this works
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users   <-- not necessary?
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

  # DELETE /users/1     <-- not necessary?
  def destroy
    @user.destroy
  end

  # GET /users/1/active_trips
  def active_trips
    @active_trips = @user.trips.where('pools.is_active': true)
    render json: @active_trips
  end
  
  # GET /users/1/active_copoolers
  def active_copoolers
    sql = "SELECT DISTINCT ON (u.id) u.* FROM users u JOIN pools p ON p.user_id = u.id
            WHERE p.is_active = true
              AND p.user_id != :uid
              AND p.trip_id in (:tids)"
    vars = {uid: @user.id, tids: @user.trips.ids}
    @active_copoolers = User.find_by_sql [sql,vars]
    render json: @active_copoolers
  end
  
  private
    # Defines the user based on the URL
    def set_user
      @user = User.find(params[:id])
    end
    
    # Confirms that the user making the request is the user about whom the request is made
    def confirm_correct_user 
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user==@user 
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:password, :password_confirmation,
        :first_name, :last_name, :has_avatar, :email, :phone, 
        :gender, :company, :position, :driving_pref, :car, 
        :radio_stations, :talkativeness, :smoke, :ac)
    end
end
