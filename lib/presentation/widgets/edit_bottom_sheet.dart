import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:weight_tracker/data/providers/auth_provider.dart';
import 'package:weight_tracker/data/providers/weight_provider.dart';
import 'package:provider/provider.dart';

class CustomEditBottomSheet extends StatefulWidget {
  CustomEditBottomSheet({
    Key? key,
    required this.weight,
    required this.unit,
    required this.id,
  }) : super(key: key);

  final String weight;
  final String unit;
  final String id;

  @override
  _CustomEditBottomSheetState createState() => _CustomEditBottomSheetState();
}

class _CustomEditBottomSheetState extends State<CustomEditBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _weights = ['kg', 'lb'];

  String _selectedUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _controller.text = widget.weight;
    if (widget.unit == 'kg') {
      _selectedUnit = 'kg';
      _weights.insert(0, 'kg');
      _weights.insert(1, 'lb');
    } else if (widget.unit == 'lb') {
      _weights.insert(0, 'lb');
      _selectedUnit = 'lb';
      _weights.insert(1, 'kg');
    }
  }

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
                'Edit Weight',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Edit your weight to the tracking list!',
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
                  child: Text('Update'),
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
                    await context
                        .read<WeightProvider>()
                        .editWeight(widget.id, _controller.text, _selectedUnit);
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
      looping: true,
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
