module ApplicationHelper
  def foo_helper(&)
    FooPresenter.new(self, expense:).render(&)
  end
end
