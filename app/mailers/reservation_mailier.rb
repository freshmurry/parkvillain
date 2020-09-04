class ReservationMailer < ApplicationMailer
  def send_email_to_guest(guest, space)
    @recipient = guest
    @space = space
    mail(to: @recipient.email, subject: "Thank you! Get ready to park!💯")
  end
end