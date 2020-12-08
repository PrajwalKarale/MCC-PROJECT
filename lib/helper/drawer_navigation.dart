import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/categories_screen.dart';
import 'package:todolist/service/category_service.dart';
import 'package:todolist/screens/todos_by_category.dart';
import 'package:todolist/screens/current_location.dart';
class DrawerNavigation extends StatefulWidget 
{
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> 
{
  List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();
  
  @override
  initState()
  {
    super.initState();
    getAllCategories();
  }

  getAllCategories()async
  {
    var categories = await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosByCategory(category: category['name'],))),
          child: ListTile(
          title: Text(category['name']),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/user.jpeg'),
                ),

                accountName: Text(
                  'Prishita Kadam'
              ),

                accountEmail: Text(
                  'prishu@email.com'
                ),
                decoration: BoxDecoration(color: Colors.blue),  
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('HOME'),
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder : (context)=>HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('CURRENT LOCATION'),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CurrentLocation())),
            ),
            ListTile(
              leading : Icon(Icons.list),
              title : Text('CATEGORIES'),
              onTap : ()=>Navigator.of(context).push(MaterialPageRoute(builder : (context)=>CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}