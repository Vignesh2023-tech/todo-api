
class CreateTodoWorker
  include Sidekiq::Worker



  def perform(todo)

    puts "===========#{todo}============="
    puts "create todo worker"

    @client = Elasticsearch::Client.new(host: 'http://localhost:9200')
    puts "====================#{@client}======================"
    @client.ping

    puts "===========================#{todo.id}==========================="

    todo_item = {
      id: todo.id,
      title: todo.title,
      description: todo.description,
    }

    # Index the todo item
    client.index(index: 'todos_index', body: todo_item)

    puts "Todo item indexed successfully!"
  end
end
