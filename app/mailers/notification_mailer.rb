class NotificationMailer < ApplicationMailer
  default from: ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@uristuslugi.local")

  def generic(user, title, body)
    @user = user
    @title = title
    @body = body
    mail(to: user.email, subject: title)
  end
end
