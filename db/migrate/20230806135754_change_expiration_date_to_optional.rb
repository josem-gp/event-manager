class ChangeExpirationDateToOptional < ActiveRecord::Migration[7.0]
  def change
    change_column_null :invitations, :expiration_date, true
  end
end
