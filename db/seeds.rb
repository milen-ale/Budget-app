# Demo data for local development and portfolio review.
# Idempotent: safe to run repeatedly via `rails db:seed`.

demo = User.find_or_create_by!(email: 'demo@example.com') do |user|
  user.name = 'Demo User'
  user.password = 'password123'
end

CATEGORIES = {
  'Groceries' => { icon: 'food', expenses: [['Weekly shop', 84.20], ['Farmers market', 23.50], ['Coffee beans', 14.99]] },
  'Transport' => { icon: 'transport', expenses: [['Monthly transit pass', 96.00], ['Fuel', 52.30]] },
  'Rent & Home' => { icon: 'housing', expenses: [['July rent', 850.00], ['New lamp', 39.99]] },
  'Fun' => { icon: 'entertainment', expenses: [['Cinema tickets', 24.00], ['Concert', 65.00]] },
  'Health' => { icon: 'health', expenses: [['Pharmacy', 18.75]] },
  'Savings' => { icon: 'savings', expenses: [] }
}.freeze

CATEGORIES.each do |name, config|
  category = demo.budget_categories.find_or_create_by!(name: name) do |c|
    c.icon = config[:icon]
  end

  config[:expenses].each do |expense_name, amount|
    category.expenses.find_or_create_by!(name: expense_name) do |e|
      e.amount = amount
      e.author = demo
    end
  end
end

puts "Seeded demo account: demo@example.com / password123 " \
     "(#{demo.budget_categories.count} categories, #{demo.expenses.count} expenses)"
