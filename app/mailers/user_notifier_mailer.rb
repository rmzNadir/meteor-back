class UserNotifierMailer < ApplicationMailer
  default from: 'Meteor <dgzrz99@gmail.com>'

  def send_sale_confirmation(user, sale)
    @user = user
    @sale = sale
    attachments.inline['logo.png'] = File.read("app/assets/images/meteor.png")
    mail(
      to: @user.email,
      subject: "Confirmación de orden No. #{@sale.id}"
    )
  end
end
