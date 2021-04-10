import 'package:flutter/cupertino.dart';
import 'package:istemanipalapp/services/dialogService.dart';

import 'package:istemanipalapp/services/locator.dart';

import '../../services/api.dart';
import '../../services/locator.dart';

class CategoryViewModel with ChangeNotifier {
  //making instace of web api and storage services to use their function
  var api = locator<Api>();

  List _categories;
  bool _isFetchingData = false;

  //getters
  List get categories => _categories;
  bool get isFetchingData => _isFetchingData;

  //setters
  _setFetchingData(value) {
    _isFetchingData = value;
    notifyListeners();
  }

  CategoryViewModel.initialize() {
    fetchCategories();
  }

  void fetchCategories() async {
    _setFetchingData(true);
    var categoryData = await api.fetchCategories();
    if (categoryData['success'] == true) {
      _categories = categoryData['active'];
    } else {
      locator<DialogService>()
          .showAlertDialog('Error', categoryData['message']);
    }
    _setFetchingData(false);
  }
}
