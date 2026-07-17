module IconHelper
  # Emoji tiles for the curated category icon set. Keys must stay in sync with
  # BudgetCategory::ICONS — spec/models/budget_category_spec.rb enforces it.
  CATEGORY_ICONS = {
    'food' => '🍔',
    'transport' => '🚗',
    'housing' => '🏠',
    'entertainment' => '🎬',
    'health' => '💊',
    'shopping' => '🛍️',
    'utilities' => '💡',
    'travel' => '✈️',
    'education' => '🎓',
    'savings' => '💰',
    'pets' => '🐾',
    'other' => '📦'
  }.freeze

  def category_icon(key, size: :md)
    tag.span(CATEGORY_ICONS.fetch(key, CATEGORY_ICONS['other']),
             class: "icon-tile icon-tile--#{size} icon-tile--#{key}",
             aria: { hidden: true })
  end
end
