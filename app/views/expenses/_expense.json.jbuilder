json.extract! expense, :id, :name, :amount, :author, :created_at, :updated_at
json.url expense_url(expense, format: :json)
