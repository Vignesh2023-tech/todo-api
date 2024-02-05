
class TodosController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :set_todo_params, only: [:create, :update]

  def index
    @todo = Todo.all
    render json: {todos: ActiveModel::SerializableResource.new(@todo, each_serializer: TodoSerializer)}
  end

  def create
    @todo = Todo.new
    @todo.title = @title
    @todo.description = @description
    @todo.save
    render json: {todos: @todo}
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.title = @title
    @todo.description = @description
    @todo.save
    render json: {todos: @todo}
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
  end

  def show
    @todo = Todo.find(params[:id])
    render json: {todos: @todo}
  end

  def deleteAll
    DeleteAllTodosWorker.perform_async()
    render json: {message: "All todos deleted"}
  end

  private
  def set_todo_params
    todo_params = params.require(:todo).permit(:title, :description)
    @title = todo_params[:title]
    @description = todo_params[:description]
  end
end
