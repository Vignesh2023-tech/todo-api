
class Todo < ApplicationRecord
  # after_save :navigate_todo_create_worker

  def navigate_todo_create_worker
    puts 'create todo worker'
    CreateTodoWorker.perform_async(self.to_json);
  end
end
