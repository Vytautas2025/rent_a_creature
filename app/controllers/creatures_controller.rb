class CreaturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :home]
  before_action :set_creature, only: [:show, :edit, :update, :book, :create_booking, :manage_bookings, :update_booking]

  def home
    if params[:query].present?
      @creatures = Creature.where(available: true).search_by_name_and_description(params[:query])
    else
      @creatures = Creature.where(available: true)
    end
  end

  def show
    @creature = Creature.find(params[:id])

    # Generate the marker with the creature's image URL
    @markers = [{
      lat: @creature.latitude,
      lng: @creature.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { creature: @creature }),
      # Add the creature image URL to the marker data
      image_url: @creature.photo.attached? ? helpers.cl_image_path(@creature.photo.key, secure: true) : nil
    }]
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.new(creature_params)
    @creature.user = current_user
    if @creature.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # view my creatures
  def my_creatures
  authenticate_user!
  @creatures = current_user.creatures
  end

  def edit
    @creature = Creature.find(params[:id])
    redirect_to root_path, alert: "You can only edit your own creatures" unless @creature.user == current_user
  end

  def update
    @creature = Creature.find(params[:id])

    if @creature.user != current_user
      redirect_to root_path, alert: "You can only edit your own creatures"
    elsif @creature.update(creature_params)
      redirect_to creature_path(@creature), notice: "Creature successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authenticate_user!

    @creature = Creature.find(params[:id])
    @creature.destroy
    redirect_to my_creatures_path, status: :see_other
  end

  def book
    authenticate_user!

    # Don't allow booking your own creature
    if @creature.user == current_user
      redirect_to @creature, alert: "You cannot book your own creature!"
      return
    end

    @booking = Booking.new
    @existing_bookings = @creature.bookings.where(status: ['pending', 'accepted'])
  end

  # Create a new booking
  def create_booking
    authenticate_user!

    @booking = Booking.new(booking_params)
    @booking.creature = @creature
    @booking.user = current_user
    @booking.status = "pending"

    if @booking.save
      redirect_to my_bookings_creature_path(@creature),
                  notice: "Booking request sent! Awaiting owner approval."
    else
      @existing_bookings = @creature.bookings.where(status: ['pending', 'accepted'])
      render :book, status: :unprocessable_entity
    end
  end

  # View bookings you've made (as a renter)
  def my_bookings
    authenticate_user!
    @bookings = current_user.bookings
  end

  # View bookings for your creature (as an owner)
  def manage_bookings
    authenticate_user!

    # Ensure user is the owner of this creature
    unless @creature.user == current_user
      redirect_to root_path, alert: "You can only manage bookings for your own creatures"
      return
    end

    @bookings = @creature.bookings
  end

  # Accept or reject a booking
  def update_booking
    authenticate_user!
    @booking = Booking.find(params[:booking_id])

    # Ensure the booking belongs to one of current user's creatures
    unless @booking.creature.user == current_user
      redirect_to root_path, alert: "You can only manage bookings for your own creatures"
      return
    end

    if @booking.update(status: params[:status])
      redirect_to manage_bookings_creature_path(@creature),
                  notice: "Booking was #{params[:status]}."
    else
      redirect_to manage_bookings_creature_path(@creature),
                  alert: "Could not update booking status."
    end
  end

  # Cancel a booking (as a renter)
  def cancel_booking
    authenticate_user!
    @booking = Booking.find(params[:id])

    # Ensure the booking belongs to current user
    unless @booking.user == current_user
      redirect_to root_path, alert: "You can only cancel your own bookings"
      return
    end

    @booking.destroy
    redirect_to my_bookings_creature_path(@booking.creature),
                notice: "Booking was cancelled."
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :description, :available, :price, :photo, :address)
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_creature
    @creature = Creature.find(params[:id])
  end
end
