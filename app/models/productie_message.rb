# == Schema Information
#
# Table name: postbus
#
#  id                       :integer(8)      not null, primary key
#  identificatieAanlevering :string(12)      not null
#  codeEI                   :string(3)       not null
#  zender                   :string(8)       not null
#  ontvanger                :string(8)       not null
#  berichtnaam              :string(255)
#  bericht                  :text(2147483647
#  gelezen                  :binary(1)
#  gearchiveerd             :binary(1)
#  betreftRetourbericht     :binary(1)       not null
#  postbusId                :integer(8)
#  aangemaaktOp             :datetime        not null
#  aangemaaktDoor           :string(60)      not null
#  gewijzigdOp              :datetime
#  gewijzigdDoor            :string(60)
#  versienummer             :integer(4)      not null
#  volledigeinhoud          :binary(21474836
#  zenderType               :string(3)       default("ZK"), not null
#  ontvangerType            :string(3)       default("ZK"), not null
#  externId                 :integer(8)
#  status                   :string(20)
#  versie                   :integer(8)
#  tekenset                 :string(10)      default("Cp1252"), not null
#  bericht_uuid             :string(50)
#  bericht_type             :string(50)
#  bericht_versie           :string(50)
#  conversatie_uuid         :string(50)
#  referentie_uuid          :string(50)
#  beschrijving             :text(2147483647
#  ontvanger_identificatie  :string(100)
#  zender_identificatie     :string(100)
#  verzonden_op             :datetime
#

class ProductieMessage < ActiveRecord::Base
  establish_connection :productie_database
  self.table_name = :postbus
  has_one :productie_message_content, foreign_key: :postbus_id

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
    where("(gewijzigdOp >= :date AND gewijzigdOp < :tomorrow) OR \
          (gewijzigdOp IS NULL AND aangemaaktOp >= :date AND aangemaaktOp < :tomorrow)",
    date: date, tomorrow: date + 1.day)
  }

  scope :not_processed, lambda { |message_ids|
    where("identificatieAanlevering NOT IN (?)", message_ids)
  }

  def self.by_id(id)
    where(identificatieAanlevering: id).first
  end

  def content
    productie_message_content.try(:volledigeInhoud)
  end

  def return_message
    self.class.find(postbusId)
  end
end