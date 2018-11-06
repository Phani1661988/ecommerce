module API  
  module V1
    class Userss < Grape::API
      include API::V1::Defaults     

      resource :userss do
       params do
        requires :email,type: String
        requires :password,type: String
      end
        post :sign_in do
          user = User.where(email: params[:email]).first
          if user.present? && user.valid_password?(params[:password])
              payload = {user_id: user.id}
              token = JWT.encode(payload, "3737ac751defc028d3a9c063e29466e1c3ed2360b31ed035932c2e68dabe0120e7e5ede733d2eb0b08b0bd7d336329cb1336e61e7bd37b0268489a4f46d65f12")
              user_hash = Hash.new
              user_hash["id"] = user.id
              user_hash["name"] = user.name
              user_hash["email"] = user.email
              user_hash["token"] = token
              user_hash
          else
            error!(:unauthorized, 401)
          end
        end
      end

      end
    end
  end