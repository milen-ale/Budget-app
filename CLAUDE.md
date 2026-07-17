# Budget App — project rules

Rails 7.0 / Ruby 3.1.2 / PostgreSQL expense tracker with Devise auth and
Hotwire (import maps — no Node build step).

## Commands

- Run the app: `bin/rails server` (Windows: `bundle exec rails server`)
- Tests: `bundle exec rspec`
- Lint: `bundle exec rubocop`
- DB: `bin/rails db:create db:migrate db:seed` (demo login: demo@example.com / password123)

## Architecture

- **Domain**: `User` → has many `BudgetCategory` → has many `Expense`.
  Both categories and expenses also belong to their `author` (User).
- **Authorization is scoping, not roles**: every controller query goes through
  `current_user.budget_categories...` — never `Model.find(params[:id])`.
  Foreign IDs must 404. Request specs enforce this; keep them passing.
- `authenticate_user!` is a default `before_action` in `ApplicationController`;
  skip it explicitly (see `SplashScreenController`) only for public pages.
- Money is `decimal(12,2)` with a DB-level `amount >= 0` check. Never float.
- Category icons are keys from `BudgetCategory::ICONS`, rendered by
  `IconHelper::CATEGORY_ICONS`. The two lists must stay in sync (a model spec
  enforces it). Add new icons in both places.

## Conventions

- Slim RESTful controllers; no service objects unless logic spans models.
- Views are partial-based components (`shared/_empty_state`, `shared/_form_errors`,
  `layouts/_navbar`, `layouts/_flash`). Reuse them; don't inline-style.
- CSS lives in one file: `app/assets/stylesheets/application.css`, mobile-first,
  BEM-ish naming, design tokens as CSS custom properties in `:root`. Use the
  tokens (`var(--space-4)`, `var(--brand)`) — no hard-coded colors or px soup.
- JavaScript is Stimulus controllers under `app/javascript/controllers` — no
  inline `<script>` tags.
- Redirects after destructive actions use `status: :see_other` (Turbo).
- Don't add gems without discussing; the Gemfile is intentionally lean.
