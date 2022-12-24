json.extract! user, :id, :name, :created_at, :updated_at
sjson.url user_url(user, format: :json)
