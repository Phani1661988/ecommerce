module API  
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
        before do
          authenticated
        end        

    helpers do
        def authenticated
          if !request.headers['Authorization'].blank?
            token = request.headers['Authorization'].split(' ').last
            begin
              decoded_token = JWT.decode(token, "3737ac751defc028d3a9c063e29466e1c3ed2360b31ed035932c2e68dabe0120e7e5ede733d2eb0b08b0bd7d336329cb1336e61e7bd37b0268489a4f46d65f12")
            rescue
              error!(:unauthorized, 401) if JWT::DecodeError
            end
          @current_user = User.where(id: decoded_token[0]["user_id"]).first
          else
            error!(:unauthorized, 401)
          end
        end
      end

      params do
        requires :email, type: String
        requires :password, type: String
        requires :password_confirmation, type: String        
      end
      post do
        if @current_user.is_admin.to_s == "true" 
         user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], name: params[:name])
         UserScope.create(cart: "read, write",  product: "read", order: "read", user_id: user.id)
         user_hash = Hash.new
         user_hash["name"] = user.name
         user_hash["cart_access"] = user.user_scope.cart
         user_hash["product_access"] = user.user_scope.product
         user_hash["order_access"] = user.user_scope.order
         user_hash
        else
            error!(:unauthorized, 401)
        end
      end

        get do
          if @current_user.is_admin.to_s == "true"
            User.all
          else
            error!(:unauthorized, 401)
          end
        end

        get :scope do
          scope_hash = Hash.new
          user_scope = @current_user.user_scope
         scope_hash["cart_access"] = user_scope.cart
         scope_hash["product_access"] = user_scope.product
         scope_hash["order_access"] = user_scope.order      
         scope_hash    
        end

        delete ":id" do 
          if @current_user.is_admin.to_s == "true"
            user = User.where(id: params[:id]).first
            user.destroy
            "User destroyed"
          else
            error!(:unauthorized, 401)
          end          
        end

      end
    end
  end
end 