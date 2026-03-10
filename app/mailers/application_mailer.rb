# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@psk-montag.ru")
  layout "mailer"
end
