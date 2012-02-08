# == Schema Information
#
# Table name: postbus_inhoud
#
#  id              :integer(8)      not null, primary key
#  postbus_id      :integer(8)      not null
#  volledigeInhoud :text
#

class AcceptatieMessageContent < ActiveRecord::Base
  establish_connection :acceptatie_database
  self.table_name = :postbus_inhoud
  belongs_to :acceptatie_message, foreign_key: :postbus_id
end