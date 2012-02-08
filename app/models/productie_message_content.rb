# == Schema Information
#
# Table name: postbus_inhoud
#
#  id              :integer(8)      not null
#  postbus_id      :integer(8)      not null
#  volledigeInhoud :text(2147483647
#

class ProductieMessageContent < ActiveRecord::Base
  establish_connection :productie_database
  self.table_name = :postbus_inhoud
  belongs_to :productie_message, foreign_key: :postbus_id
end