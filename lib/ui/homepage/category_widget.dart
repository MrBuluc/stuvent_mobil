import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/styleguide.dart';
import '../../app_state.dart';
import '../../model/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedCategoryId == category.categoryId;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState.updateCategoryId(category.categoryId);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.white : Color(0x99FFFFFF),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              category.icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              category.name,
              style: isSelected ? selectedCategoryTextStyle : categoryTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
