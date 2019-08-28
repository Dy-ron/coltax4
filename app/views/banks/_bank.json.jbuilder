json.extract! bank, :id, :puc, :trans_type, :detail, :trans_value, :balance, :bank_id, :bank, :users_id, :verified, :created_at, :updated_at
json.url bank_url(bank, format: :json)
