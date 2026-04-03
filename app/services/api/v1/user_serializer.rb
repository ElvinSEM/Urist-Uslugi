module Api
  module V1
    class UserSerializer
      def self.call(user)
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          role: user.role
        }
      end
    end
  end
end
