import 'package:flutter/material.dart';
import 'package:todolist/model/category.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/service/category_service.dart';
class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> 
{
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    getAllCategories();
  }
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  getAllCategories() async
  {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState((){
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context , categoryId) async
  {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No name';
      _editCategoryDescriptionController.text = category[0]['description'] ?? 'No Description';
    });
    _editformDialog(context);
  }

  _showformDialog(BuildContext context)
  {
    return showDialog(context:context,barrierDismissible: true , builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.red,
            onPressed: ()=>Navigator.pop(context),
            child: Text(
              'CANCEL'
            ),
          ),
          FlatButton(
            color: Colors.green,
            onPressed: ()async{
              _category.name = _categoryNameController.text;
              _category.description = _categoryDescriptionController.text;
              // _categoryService.saveCategory(_category);
              var result = await _categoryService.saveCategory(_category);
              print(result);
              Navigator.pop(context);
              getAllCategories();
            },
            child: Text(
              'SAVE'
            ),
          )
        ],
        title:Text(
          'ENTER CATEGORIES'
        ) ,
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller:_categoryNameController ,
                decoration: InputDecoration(
                  hintText: 'ENTER CATEGORY',
                  labelText: 'CATEGORY'
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'WRITE DESCRIPTION',
                  labelText: 'DESCRIPTION'
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _editformDialog(BuildContext context)
  {
    return showDialog(context:context,barrierDismissible: true , builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.red,
            onPressed: ()=>Navigator.pop(context),
            child: Text(
              'CANCEL'
            ),
          ),
          FlatButton(
            color: Colors.green,
            onPressed: ()async{
              _category.id = category[0]['id'];
              _category.name = _editCategoryNameController.text;
              _category.description = _editCategoryDescriptionController.text;
              // _categoryService.saveCategory(_category);
              var result = await _categoryService.updateCategory(_category);
              if(result > 0)
              {
                Navigator.pop(context);
                getAllCategories();
                _showSuccessSnackBar(Text('UPDATED SUCCESFULLY'));
              }
              // print(result);
            },
            child: Text(
              'UPDATE'
            ),
          )
        ],
        title:Text(
          'EDIT CATEGORIES FORM'
        ) ,
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller:_editCategoryNameController ,
                decoration: InputDecoration(
                  hintText: 'ENTER CATEGORY',
                  labelText: 'CATEGORY'
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'WRITE DESCRIPTION',
                  labelText: 'DESCRIPTION'
                ),
              )
            ],
          ),
        ),
      );
    });
  }
  _deleteformDialog(BuildContext context , categoryId)
  {
    return showDialog(context:context,barrierDismissible: true , builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.blue,
            onPressed: ()=>Navigator.pop(context),
            child: Text(
              'CANCEL'
            ),
          ),
          FlatButton(
            color: Colors.red,
            onPressed: ()async{
              var result = await _categoryService.deleteCategory(categoryId);
              if(result > 0)
              {
                Navigator.pop(context);
                getAllCategories();
                _showSuccessSnackBar(Text('DELETED SUCCESFULLY'));
              }
              // print(result);
            },
            child: Text(
              'DELETE'
            ),
          )
        ],
        title:Text(
          'DELETE CATEGORIES'
        ) ,
      );
    });
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
        leading: RaisedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder : (context) => HomeScreen())),
          elevation: 0.0,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.blue,
        ),
        title: Text('CATEGORIES'),
      ),
      body:ListView.builder(itemCount:_categoryList.length, itemBuilder: (context , index){
        return Padding(
          padding:EdgeInsets.only(top:8.0 , left: 16.0 , right:16.0),
          child: Card(
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  _editCategory(context , _categoryList[index].id);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: (){
                      _deleteformDialog(context , _categoryList[index].id);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showformDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}