# == Schema Information
#
# Table name: postbus
#
#  id                 :integer(8)      not null, primary key
#  identification     :string(12)
#  codeEI             :string(3)
#  senderUzovi        :string(8)
#  receiverUzovi      :string(8)
#  retourMessage      :boolean
#  postbusId          :integer(8)
#  creationDate       :datetime        not null
#  createdBy          :string(255)     not null
#  changedDate        :datetime
#  changedBy          :string(60)
#  senderType         :string(10)      not null
#  receiverType       :string(10)      not null
#  externId           :integer(8)
#  status             :string(20)
#  characterSet       :string(10)      not null
#  messageId          :string(50)
#  messageName        :string(255)
#  messageType        :string(50)
#  messageVersion     :string(10)
#  converationId      :string(50)
#  refMessageId       :string(50)
#  messageDescription :string(50)
#  sender             :string(100)
#  receiver           :string(100)
#  sentDate           :datetime
#  tennant_sender     :string(255)
#  tennant_receiver   :string(255)
#
require "base64"

class AcceptatieMessage < ActiveRecord::Base
  establish_connection :acceptatie_database
  self.table_name = :postbus
  has_one :acceptatie_message_content, foreign_key: :postbus_id

  EI_CODES = {
    388 => 389,
    393 => 394,
    395 => 396,
    397 => 398,
    404 => 405
  }

  scope :in, where(codeEI: EI_CODES.keys)

  scope :out, where(codeEI: EI_CODES.values)

  scope :from_date, lambda { |date|
    where("(creationDate >= :date AND creationDate < :tomorrow)",
    date: date, tomorrow: date + 1)
  }

  def self.by_id(id)
    where(identification: id).first
  end

  def content
    Base64.decode64 acceptatie_message_content.try(:volledigeInhoud)
  end

  def return_message
    self.class.find(postbusId)
  end
end