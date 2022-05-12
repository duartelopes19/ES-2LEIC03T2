import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/view/Widgets/exam_filter_menu.dart';

class RatePageTitle extends StatelessWidget {
  final String name;
  
  const RatePageTitle({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),
          ),
        ],
      )
      );
  }
}