module API  
  module V1
    class Base < Grape::API
      mount API::V1::Users
      mount API::V1::Userss
      mount API::V1::Products
    end
  end
end  