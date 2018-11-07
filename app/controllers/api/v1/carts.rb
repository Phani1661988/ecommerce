module API  
  module V1
    class Carts < Grape::API
      include API::V1::Defaults

      resource :carts do
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
        requires :products, type: Array
      end
      post do 
        cart = Cart.new(products_list: params[:products], user_id: @current_user.id)
        if cart.save
         order = Order.create(products_list: params[:products], user_id: @current_user.id)
        end
        order
      end

    end
  end
end
end
