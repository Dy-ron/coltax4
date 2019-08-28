# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def user_info
    user = User.last
    campaign = Campaign.where(active: true).first
    UserMailer.user_info(user, campaign)
  end
end
