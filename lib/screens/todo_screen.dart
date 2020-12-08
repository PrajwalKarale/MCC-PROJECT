import 'package:flutter/material.dart';
import 'package:todolist/service/category_service.dart';
import 'package:todolist/service/todo_service.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist/screens/home_screen.dart';
class TodoScreen extends StatefulWidget 
{
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> 
{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _selectedValue;


  @override
  void initState()
  {
    super.initState();
    _loadcategories();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android ,iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

  }
  Future onSelectNotification(String payload)
  {
    debugPrint("payload: $payload");
    showDialog(
        context: context,
        builder: (_)=>new AlertDialog(
          title: new Text(
            'NOTIFICATION'
          ),
          content:new Text(
            '$payload',
          ),
        ),
      );
  }

  var _categories = List<DropdownMenuItem>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  _loadcategories() async
  {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async
  {
    var _pickDate = await showDatePicker(
      context: context, 
      initialDate: _dateTime, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
      );
    if(_pickDate!=null){
      setState(() {
        _dateTime = _pickDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickDate);
      });
    }
  }

  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('CREATE TODO'),
      ),
      body:SingleChildScrollView(
          child: Container(
          padding: const EdgeInsets.all(30.0),
          color: Colors.white,
          child:Container(
            child:new Center(
              child: Column(
                children: <Widget>[
                   Padding(
                     padding: EdgeInsets.only(top:20.0),
                  ),
                  TextFormField(
                    controller: _todoTitleController,
                    decoration:InputDecoration(
                      labelText: 'TITLE',
                      hintText: 'Write ToDo Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                  ),
                  TextFormField(
                    controller: _todoDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'DESCRIPTION',
                      hintText: 'Write a Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0)
                  ),
                  TextField(
                    controller: _todoDateController,
                    decoration: InputDecoration(
                      labelText: 'DATE',
                      hintText: 'Pick a Date',
                      prefix: InkWell(
                        onTap: (){
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    items: _categories, 
                    hint: Text('CATEGORY'),
                    onChanged: (value){
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:30),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: RaisedButton(
                      elevation: 10.0,
                      splashColor: Colors.yellow[200],
                      animationDuration: Duration(milliseconds: 2000),
                      onPressed: ()async
                      {
                        var todoObject = Todo();
                        todoObject.title = _todoTitleController.text;
                        todoObject.description = _todoDescriptionController.text;
                        todoObject.isFinished = 0;
                        todoObject.category = _selectedValue.toString();
                        todoObject.todoDate = _todoDateController.text;

                        var _todoService = TodoService();
                        var result = await _todoService.saveTodo(todoObject);
                        if(result > 0)
                        {
                          _showSuccessSnackBar(Text('CREATED SUCCESSFULLY'));
                        }

                        print(result);
                        showNotification();
                        Navigator.of(context).push(MaterialPageRoute(builder : (context)=>HomeScreen()));
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child:Text(
                        'SAVE',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 20,
                         ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
  showNotification()async
  {
    var android = new AndroidNotificationDetails('channelId', 'channel NAME', 'CHANNEL DESCRIPTION');
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android,iOS:iOS);
    await flutterLocalNotificationsPlugin.show(0,'TODO LIST','TASK NOTED',platform);
  }
}