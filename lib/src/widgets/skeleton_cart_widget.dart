import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonCartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: double.infinity,
          child: SkeletonAnimation(
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 14.0,
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return SkeletonAnimation(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: AppTheme.white,
                    child: ListTile(
                      leading: Container(
                        width: 125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.grey[300],
                        ),
                      ),
                      title: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.grey[200],
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: 20,
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.grey[200],
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: 18,
                              width: 125,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              )),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );

              }),
        ),
      ]),
    );
  }
}
