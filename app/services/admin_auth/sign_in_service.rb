# frozen_string_literal: true

module AdminAuth
  class SignInService < BaseService
    def call
      contract = AdminAuth::SignInContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      admin = ::Admin.find_by(email: data[:email])
      return unauthorized([ "Invalid email or password" ]) unless admin&.authenticate(data[:password])

      token = JwtService.encode({ admin_id: admin.id, email: admin.email })
      success({ token: token })
    end
  end
end
