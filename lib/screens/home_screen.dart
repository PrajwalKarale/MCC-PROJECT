import 'package:flutter/material.dart';
import 'package:todolist/helper/drawer_navigation.dart';
import 'package:todolist/screens/todo_screen.dart';
import 'package:todolist/service/todo_service.dart';
import 'package:todolist/model/todo.dart';

class HomeScreen extends StatefulWidget
{
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  @override
  initState()
  {
    super.initState();
    getAllTodos();
  }

  getAllTodos()async
  {
    _todoService = TodoService();
    _todoList = List<Todo>();
    var todos = await _todoService.readTodos();

    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }
  @override
  Widget build(BuildContext context)
  {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'PRODUCTIVITY APP',
          ),
        ),
        drawer:DrawerNavigation(),
        body:ListView.builder(itemCount:_todoList.length,itemBuilder:(context,index){
          return Padding(
              padding:EdgeInsets.only(top:8.0 , left:8.0 , right:8.0),
              child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child:ListTile(
                title: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children:<Widget> [
                    Text(
                      _todoList[index].title ?? 'NO TITLE'
                    ),
                  ],
                ),
                subtitle: Text(
                  _todoList[index].category ?? 'NO CATEGORY'
                ),
                trailing: Text(
                  _todoList[index].todoDate ?? 'NO DATE'
                ),
              ) ,
            ),
          );
        },
        ) ,
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder : (context) => TodoScreen())),
          child: Icon(
            Icons.add,
          ),
        ),
      );
  }

}