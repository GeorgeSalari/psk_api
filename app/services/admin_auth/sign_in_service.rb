# frozen_string_literal: true

module AdminAuth
  class SignInService
    def initialize(input, serializer: nil)
      @input = input
    end

    def call
      contract = AdminAuth::SignInContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      admin = ::Admin.find_by(email: data[:email])
      return unauthorized([ "Invalid email or password" ]) unless admin&.authenticate(data[:password])

      token = JwtService.encode({ admin_id: admin.id, email: admin.email })
      { success: true, data: { token: token } }
    end

    private

    def unauthorized(errors)
      { success: false, unauthorized: true, errors: errors }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
