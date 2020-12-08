import 'package:todolist/repositories/repository.dart';
import 'package:todolist/model/todo.dart';

class TodoService
{
  Repository _repository;
  
  TodoService()
  {
    _repository = Repository();
  }

  saveTodo(Todo todo) async
  {
    return await _repository.insertData('todos', todo.todoMap());
  }
  // read todos
  readTodos()async
  {
    return await _repository.readData('todos');
  }
  //read todo by category name
  readTodosByCategory(category)async
  {
    return await _repository.readDataByColumnName('todos','category', category);
  }
}