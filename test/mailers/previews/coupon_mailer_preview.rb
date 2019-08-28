# Preview all emails at http://localhost:3000/rails/mailers/coupon_mailer
class CouponMailerPreview < ActionMailer::Preview
  def coupon_email
    CouponMailer.coupon_email(Coupon.first, "Holi, recuerdame plis", Campaign.first)
  end
end
