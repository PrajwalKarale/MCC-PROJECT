import 'package:todolist/model/category.dart';
import 'package:todolist/repositories/repository.dart';
class CategoryService
{
  Repository _repository;

  CategoryService()
  {
    _repository = Repository();
  }
  saveCategory(Category category) async
  {
      // print(category.name);
      // print(category.description);
      return await _repository.insertData('categories',category.categoryMap());
  }
  readCategories()async
  {
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId)async
  {
    return await _repository.readDataById('categories' , categoryId);
  }

  updateCategory(Category category)async
  {
    return await _repository.updateData('categories' , category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories' , categoryId);
  }
}