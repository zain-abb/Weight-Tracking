import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:weight_tracker/data/providers/auth_provider.dart';
import 'package:weight_tracker/data/providers/weight_provider.dart';
import 'package:provider/provider.dart';

import 'edit_bottom_sheet.dart';

class WeightList extends StatelessWidget {
  WeightList({
    Key? key,
    required this.weights,
  }) : super(key: key);

  List<Weight> weights;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: weights.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTileTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                tileColor: Theme.of(context).backgroundColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                onTap: () {
                  _editBottomSheet(context, weights[index].weight,
                      weights[index].unit, weights[index].id);
                },
                title: Text(
                  '${weights[index].weight} ${weights[index].unit}',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      timeago.format(weights[index].timestamp.toDate()),
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                    Text(
                      'id: ${weights[index].userId}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _editBottomSheet(context, weights[index].weight,
                              weights[index].unit, weights[index].id);
                        },
                        icon: Icon(
                          CupertinoIcons.pencil_ellipsis_rectangle,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await context
                              .read<WeightProvider>()
                              .deletWeight(weights[index].id);
                          Loader.hide();
                        },
                        icon: Icon(
                          CupertinoIcons.delete,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _editBottomSheet(
      BuildContext context, String weight, String unit, String id) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomEditBottomSheet(weight: weight, unit: unit, id: id);
      },
    );
  }
}
