# frozen_string_literal: true

class CallRequestMailer < ApplicationMailer
  def notification(call_request)
    @call_request = call_request
    mail(
      to: ENV.fetch("NOTIFICATION_EMAIL", "PSKMontag23@yandex.ru"),
      subject: "Запрос на звонок"
    )
  end
end
