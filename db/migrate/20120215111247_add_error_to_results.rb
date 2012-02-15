class AddErrorToResults < ActiveRecord::Migration
  def change
    add_column :results, :error, :string
  end
end