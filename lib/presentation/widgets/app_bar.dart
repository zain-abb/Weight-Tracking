import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/data/providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Container(
        height: 28,
        child: Text(
          '$title',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            String uid = context.read<AuthProvider>().currentUserId;
            _logoutBottomSheet(context, uid);
          },
          icon: Icon(
            CupertinoIcons.person_crop_circle,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  _logoutBottomSheet(BuildContext context, String currentUserUid) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.person_crop_circle,
                color: Theme.of(context).primaryColor,
                size: 88,
              ),
              SizedBox(height: 15),
              Text(
                'Guest User ID: $currentUserUid',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!,
              ),
              SizedBox(height: 34),
              CupertinoButton.filled(
                child: Text('Sign Out'),
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
                  await context.read<AuthProvider>().signOut();
                  Loader.hide();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
