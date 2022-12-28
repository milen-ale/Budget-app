module ApplicationHelper
  def foo_helper(&block)
    FooPresenter.new(self, expense: expense).render(&block)
  end
end