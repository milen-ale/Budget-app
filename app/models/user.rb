class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :budget_categories, foreign_key: :author_id, inverse_of: :author, dependent: :destroy
  has_many :expenses, foreign_key: :author_id, inverse_of: :author, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  def total_spent
    expenses.sum(:amount)
  end
end
