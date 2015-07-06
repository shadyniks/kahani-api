class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    users = User.all
    render json: users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  def authenticate
    user = JSON.parse(User.authenticate(params[:email], params[:password]).to_json)
    if user["id"].nil?
      render json: user, :status => 400
    else
      render json: user
    end
  end

  # POST /users
  # POST /users.json
  def create
    puts "Hello ====== #{user_params.inspect}"
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render json: @user.errors
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render json: {:status=>true}
    else
      render json: @user.errors
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      puts "Hello2 ====== #{params.inspect}"
      params.permit(:first_name, :last_name, :email, :password, :zipcode)
    end
end
