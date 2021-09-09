import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/data/providers/weight_provider.dart';
import 'package:weight_tracker/presentation/widgets/app_bar.dart';
import 'package:weight_tracker/presentation/widgets/edit_bottom_sheet.dart';
import 'package:weight_tracker/presentation/widgets/empty_weight_list.dart';
import 'package:weight_tracker/presentation/widgets/bottom_sheet.dart';
import 'package:weight_tracker/presentation/widgets/weight_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Weights'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(CupertinoIcons.add),
        onPressed: () {
          _addBottomSheet(context);
        },
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: context.watch<WeightProvider>().fetchOrDisplayWeights(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Weight> weights = [];
                snapshot.data!.docs.forEach((element) {
                  weights.add(Weight.fromDocument(element));
                });

                if (weights.isEmpty) {
                  return EmptyWeightList(
                    onPressed: () {
                      _addBottomSheet(context);
                    },
                  );
                } else {
                  return WeightList(
                    weights: weights,
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                );
              }
            }),
      ),
    );
  }

  _addBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomBottomSheet();
      },
    );
  }
}
