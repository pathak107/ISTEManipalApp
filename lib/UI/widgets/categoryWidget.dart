import 'package:flutter/material.dart';
import 'package:istemanipalapp/consts/routes.dart';
import 'package:istemanipalapp/consts/urls.dart';
import 'package:istemanipalapp/logic/models/Date.dart';
import 'package:istemanipalapp/services/locator.dart';
import 'package:istemanipalapp/services/navigationService.dart';

class CategoryWidget extends StatelessWidget {
  final String name;
  final Date startDate;
  final String poster;
  final List events;

  CategoryWidget({this.name, this.startDate, this.poster, this.events});

  @override
  Widget build(BuildContext context) {
    var navigator = locator<NavigationService>();
    return GestureDetector(
      onTap: () {
        navigator.navigateWithContext(EVENTS, context,
            arguments: {'events': events, 'category_name': name});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                this.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                startDate.date + " " + startDate.month,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.watch),
                  Text(
                    startDate.time,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              )
            ],
          ),
          Stack(children: <Widget>[
            Opacity(
              opacity: 1,
              child: Image.network(
                BASE_URL + this.poster,
                width: 200,
                height: 200,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
