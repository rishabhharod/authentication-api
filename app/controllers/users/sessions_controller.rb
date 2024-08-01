class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    #debugger
    user = User.find_by(email: params[:user][:email])
    if(!user.nil?)
      render json: {
        status: {code: 200, message: 'Logged in sucessfully.'},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "user not found "
      }, status: :unauthorized
    end
  end
  def respond_to_on_destroy
    debugger
    jwt_payload = JWT.decode(request.headers['authorization'].split(' ').last,Rails.application.credentials.fetch(:secret_key_base)).first
    debugger
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end