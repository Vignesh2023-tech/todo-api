
class DeleteAllTodosWorker
  include Sidekiq::Worker

  def perform
    Todo.delete_all
  end
end
