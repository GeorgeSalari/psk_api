# frozen_string_literal: true

module AdminAuth
  class SignInService
    def initialize(params)
      @params = params
    end

    def call
      contract = AdminAuth::SignInContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      admin = ::Admin.find_by(email: data[:email])
      return failure(["Invalid email or password"]) unless admin&.authenticate(data[:password])

      token = JwtService.encode({ admin_id: admin.id, email: admin.email })
      success(token)
    end

    private

    def success(token)
      { success: true, token: token }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
