class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :creature

  validates :start_date, :end_date, presence: true
  validates :status, inclusion: { in: %w[pending accepted rejected] }

  validate :end_date_after_start_date
  validate :dates_available

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def dates_available
    return if end_date.blank? || start_date.blank?

    overlapping_bookings = creature.bookings
      .where(status: ['pending', 'accepted'])
      .where.not(id: id) # Exclude current booking when updating
      .where(start_date: ..end_date).where(end_date: start_date..)

    if overlapping_bookings.exists?
      errors.add(:base, "The creature is already booked for selected dates")
    end
  end
end
