class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    date_from = Date.parse(calendar_params[:start_date])
    date_to = Date.parse(calendar_params[:end_date])

    (date_from..date_to).each do |date|
      calendar = Calendar.where(space_id: params[:space_id], day: date)

      if calendar.present?
        calendar.update_all(price: calendar_params[:price], status: calendar_params[:status])
      else
        Calendar.create(
          space_id: params[:space_id],
          day: date,
          price: calendar_params[:price],
          status: calendar_params[:status]
        )
      end
    end

    redirect_to host_calendar_path
  end
  
  def host
    @spaces = current_user.spaces

    params[:start_date] ||= Date.current.to_s
    params[:space_id] ||= @spaces[0] ? @spaces[0].id : nil
  
    if params[:q].present?
      params[:start_date] = params[:q][:start_date]
      params[:space_id] = params[:q][:space_id]
    end
  
    @search = Reservation.ransack(params[:q])
  
    if params[:space_id]
      @space = Space.find(params[:space_id])
      start_date = Date.parse(params[:start_date])
  
      first_of_month = (start_date - 1.months).beginning_of_month # => Jun 1
      end_of_month = (start_date + 1.months).end_of_month # => Aug 31
  
      @events = @space.reservations.joins(:user)
                      .select('reservations.*, users.fullname, users.image, users.email, users.uid')
                      .where('(start_date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
      @events.each{ |e| e.image = avatar_url(e) }
      @days = Calendar.where("space_id = ? AND day BETWEEN ? AND ?", params[:space_id], first_of_month, end_of_month)
    else
      @space = nil
      @events = []
      @days = []
    end
  end

  private
    def calendar_params
      params.require(:calendar).permit([:price, :status, :start_date, :end_date])
    end
end