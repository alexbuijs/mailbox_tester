# == Schema Information
#
# Table name: results
#
#  id           :integer         not null, primary key
#  message_id   :string(255)
#  message_type :string(255)
#  message_date :datetime
#  identical    :boolean
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Result < ActiveRecord::Base
  scope :in, where(message_type: 'in')

  scope :out, where(message_type: 'out')

  scope :from_date, lambda { |date|
    where("(message_date >= :date AND message_date < :tomorrow)",
    date: date, tomorrow: date + 1.day)
  }

  scope :mismatch, where(identical: false)
end