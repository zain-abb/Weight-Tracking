import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:weight_tracker/data/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            Image.asset(
              'assets/exercise.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Spacer(flex: 1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Track Your Weight',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(flex: 1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '“I believe that every human has a finite amount of heartbeats. I don\'t intend to waste any of mine running around doing exercises.”',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14),
              ),
            ),
            Spacer(flex: 1),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- Neil Armstrong',
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(fontStyle: FontStyle.italic, fontSize: 10),
              ),
            ),
            Spacer(flex: 6),
            CupertinoButton.filled(
              child: Text(
                'Continue as Guest',
              ),
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
                String uid = await context.read<AuthProvider>().signIn();
                print(uid);
                Loader.hide();
              },
            ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }

  // Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => HomeScreen()));

}
