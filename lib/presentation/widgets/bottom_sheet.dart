import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:weight_tracker/data/providers/auth_provider.dart';
import 'package:weight_tracker/data/providers/weight_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    Key? key,
  }) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  final List<String> _weights = ['kg', 'lb'];

  String _selectedUnit = 'kg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Weight',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Add your weight to the tracking list!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _textField(_controller),
                  ),
                  SizedBox(
                    width: 75,
                    height: 50,
                    child: _optionPicker(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: CupertinoButton.filled(
                  child: Text('Add'),
                  onPressed: () async {
                    Loader.show(
                      context,
                      isAppbarOverlay: true,
                      isBottomBarOverlay: true,
                      progressIndicator: Center(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      themeData: Theme.of(context),
                    );
                    String uid = context.read<AuthProvider>().currentUserId;
                    String result = await context
                        .read<WeightProvider>()
                        .createWeight(_controller.text, _selectedUnit, uid);
                    print(result);
                    Loader.hide();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoPicker _optionPicker(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.5,
      squeeze: 1,
      diameterRatio: 0.5,
      backgroundColor: Colors.white,
      onSelectedItemChanged: (x) {
        _selectedUnit = _weights[x];
      },
      children: _weights
          .map(
            (item) => Center(
              child: Text(
                '$item',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          )
          .toList(),
      itemExtent: 25,
    );
  }

  CupertinoTextField _textField(TextEditingController controller) {
    return CupertinoTextField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Icon(
          CupertinoIcons.gauge_badge_plus,
          color: Colors.grey,
        ),
      ),
      controller: controller,
      padding: const EdgeInsets.all(10),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.number,
      placeholder: 'your weight',
    );
  }
}
