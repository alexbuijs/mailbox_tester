class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string   :message_id
      t.string   :message_type
      t.datetime :message_date
      t.boolean  :identical

      t.timestamps
    end
  end
end