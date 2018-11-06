module API  
  module V1
    class Products < Grape::API
      include API::V1::Defaults

      resource :products do
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

      get do 
        Product.all
      end

      params do
        requires :name
        requires :value
      end
      post do 
        if @current_user.is_admin.to_s == "true" 
        product = Product.create(name: params[:name], value: params[:value])
        product
        else
            error!(:unauthorized, 401)
        end        
      end

      params do
        requires :name
        requires :value
      end
      put ':id' do 
        if @current_user.is_admin.to_s == "true" 
        product = Product.where(id: params[:id]).first
        product.name = params[:name]
        product.value = params[:value]
        product
        else
            error!(:unauthorized, 401)
        end                
      end

      delete ':id' do 
        if @current_user.is_admin.to_s == "true"
          product = Product.where(id: params[:id]).first
          product.destroy
          "Item destroyed"
        else
          error!(:unauthorized, 401)
        end
      end

      end
    end
  end
end 