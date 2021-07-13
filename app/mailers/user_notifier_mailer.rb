class UserNotifierMailer < ApplicationMailer
  default from: 'dgzrz99@gmail.com'

  def send_sale_confirmation(user, sale)
    @user = user
    @sale = sale
    attachments.inline['logo.png'] = File.read("app/assets/images/meteor.png")
    mail( to: @user.email,
          subject: 'Thanks for signing up for our amazing app' )
  end
end
