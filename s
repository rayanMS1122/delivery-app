[1mdiff --cc .gitignore[m
[1mindex 29a3a50,b05a139..0000000[m
Binary files differ
[1mdiff --cc index.js[m
[1mindex dabca06,f1b78c2..0000000[m
[1m--- a/index.js[m
[1m+++ b/index.js[m
[1mdiff --cc lib/controllers/login_controller.dart[m
[1mindex e29a8b4,8b1d4b8..0000000[m
[1m--- a/lib/controllers/login_controller.dart[m
[1m+++ b/lib/controllers/login_controller.dart[m
[1mdiff --cc lib/controllers/profile_controller.dart[m
[1mindex 63b33eb,8a1dd03..0000000[m
[1m--- a/lib/controllers/profile_controller.dart[m
[1m+++ b/lib/controllers/profile_controller.dart[m
[1mdiff --cc lib/controllers/signup_controller.dart[m
[1mindex 5e682bf,9fa4869..0000000[m
[1m--- a/lib/controllers/signup_controller.dart[m
[1m+++ b/lib/controllers/signup_controller.dart[m
[1mdiff --cc lib/main.dart[m
[1mindex 8e21919,cc52cf3..0000000[m
[1m--- a/lib/main.dart[m
[1m+++ b/lib/main.dart[m
[1mdiff --cc lib/screens/all_screen.dart[m
[1mindex a6c7e57,3043caf..0000000[m
[1m--- a/lib/screens/all_screen.dart[m
[1m+++ b/lib/screens/all_screen.dart[m
[1mdiff --cc lib/screens/authentication/login.dart[m
[1mindex f55816c,1a8062f..0000000[m
[1m--- a/lib/screens/authentication/login.dart[m
[1m+++ b/lib/screens/authentication/login.dart[m
[1mdiff --cc lib/screens/authentication/register.dart[m
[1mindex e4cbe36,555cc09..0000000[m
[1m--- a/lib/screens/authentication/register.dart[m
[1m+++ b/lib/screens/authentication/register.dart[m
[1mdiff --cc lib/screens/favorites_screen.dart[m
[1mindex 0df66b4,71c1ef4..0000000[m
[1m--- a/lib/screens/favorites_screen.dart[m
[1m+++ b/lib/screens/favorites_screen.dart[m
[1mdiff --cc lib/screens/history_screen.dart[m
[1mindex 3e6cc34,5eb59ac..0000000[m
[1m--- a/lib/screens/history_screen.dart[m
[1m+++ b/lib/screens/history_screen.dart[m
[1mdiff --cc lib/screens/home_screen.dart[m
[1mindex 7795894,da32b2f..0000000[m
[1m--- a/lib/screens/home_screen.dart[m
[1m+++ b/lib/screens/home_screen.dart[m
[36m@@@ -1,9 -1,13 +1,12 @@@[m
  import 'package:delivery_app/api/api.dart';[m
  import 'package:delivery_app/controllers/home_controller.dart';[m
[31m -import 'package:delivery_app/controllers/login_controller.dart';[m
  import 'package:delivery_app/controllers/product_controller.dart';[m
  import 'package:delivery_app/models/product.dart';[m
[32m+ import 'package:delivery_app/screens/favorites_screen.dart';[m
[32m+ import 'package:delivery_app/screens/password_change.dart';[m
  import 'package:delivery_app/screens/product_detail_screen.dart';[m
  import 'package:delivery_app/screens/profile_screen.dart';[m
[32m+ import 'package:delivery_app/screens/search_screen.dart';[m
  import 'package:delivery_app/widgets/bottom_navigation.dart';[m
  import 'package:delivery_app/widgets/build_featured_products.dart';[m
  import 'package:delivery_app/widgets/category_tabs.dart';[m
[36m@@@ -145,7 -153,9 +152,9 @@@[m [mclass _HomeScreenState extends State<Ho[m
              floatingActionButtonLocation:[m
                  FloatingActionButtonLocation.centerFloat,[m
            ),[m
[31m-           drawer: DrawerWidget(onSignOut: () {}),[m
[32m+           drawer: DrawerWidget(onSignOut: () {[m
[31m -            LoginController.logoutUser();[m
[32m++            loginlogoutUser[m
[32m+           }),[m
            backdrop: Container([m
              width: double.infinity,[m
              height: double.infinity,[m
[1mdiff --cc lib/screens/offer_screen.dart[m
[1mindex c601c2d,65e6744..0000000[m
[1m--- a/lib/screens/offer_screen.dart[m
[1m+++ b/lib/screens/offer_screen.dart[m
[1mdiff --cc lib/screens/profile_screen.dart[m
[1mindex dc6d94c,606e399..0000000[m
[1m--- a/lib/screens/profile_screen.dart[m
[1m+++ b/lib/screens/profile_screen.dart[m
[1mdiff --cc lib/widgets/drawer_widget.dart[m
[1mindex 7172517,1ab779f..0000000[m
[1m--- a/lib/widgets/drawer_widget.dart[m
[1m+++ b/lib/widgets/drawer_widget.dart[m
[1mdiff --cc package-lock.json[m
[1mindex 5c8cb12,6b58162..0000000[m
[1m--- a/package-lock.json[m
[1m+warning: in the working copy of 'linux/flutter/generated_plugin_registrant.cc', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'linux/flutter/generated_plugin_registrant.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'linux/flutter/generated_plugins.cmake', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'macos/Flutter/GeneratedPluginRegistrant.swift', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'windows/flutter/generated_plugin_registrant.cc', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'windows/flutter/generated_plugin_registrant.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'windows/flutter/generated_plugins.cmake', LF will be replaced by CRLF the next time Git touches it
++ b/package-lock.json[m
[1mdiff --cc package.json[m
[1mindex 804b44a,4e43c1c..0000000[m
[1m--- a/package.json[m
[1m+++ b/package.json[m
[36m@@@ -3,6 -3,7 +3,10 @@@[m
    "version": "1.0.0",[m
    "description": "A new Flutter project.",[m
    "main": "index.js",[m
[32m++ [m
[32m++ [m
[32m+   "type": "module",[m
[32m++ [m
    "directories": {[m
      "lib": "lib",[m
      "test": "test"[m
[36m@@@ -14,11 -15,15 +18,24 @@@[m
    "author": "",[m
    "license": "ISC",[m
    "dependencies": {[m
[32m++ [m
[32m +    "cors": "^2.8.5",[m
[32m +    "dotenv": "^16.4.7",[m
[32m +    "express": "^4.21.2",[m
[32m +    "mongodb": "^6.13.1",[m
[32m +    "mongoose": "^8.10.2",[m
[31m-     "nodemon": "^3.1.9"[m
[32m++    "nodemon": "^3.1.9",[m
[32m++ [m
[32m+     "bcrypt": "^5.1.1",[m
[32m+     "cors": "^2.8.5",[m
[32m+     "dotenv": "^16.4.7",[m
[32m+     "express": "^4.21.2",[m
[32m+     "express-validator": "^7.2.1",[m
[32m+     "jsonwebtoken": "^9.0.2",[m
[32m+     "mongodb": "^6.13.1",[m
[32m+     "mongoose": "^8.10.2",[m
[32m+     "nodemon": "^3.1.9",[m
[32m+     "winston": "^3.17.0"[m
[32m++ [m
    }[m
  }[m
[1mdiff --cc pubspec.lock[m
[1mindex 6087226,372fb6a..0000000[m
[1m--- a/pubspec.lock[m
[1m+++ b/pubspec.lock[m
[1mdiff --cc pubspec.yaml[m
[1mindex 7021e57,2151e12..0000000[m
[1m--- a/pubspec.yaml[m
[1m+++ b/pubspec.yaml[m
[36m@@@ -30,7 -30,8 +30,11 @@@[m [mdependencies[m
    cached_network_image: ^3.4.1[m
    flutter_rating_bar: ^4.0.1[m
    shimmer: ^3.0.0[m
[32m++ [m
[32m++ [m
[32m+   flutter_credit_card: ^4.1.0[m
[32m+ [m
[32m +[m
  dev_dependencies:[m
    flutter_test:[m
      sdk: flutter[m
[36m@@@ -43,7 -44,9 +47,12 @@@[m [mflutter[m
  [m
    assets:[m
      - assets/[m
[31m-   [m
[32m++ [m
[32m++ [m
[32m+     - assets/chip.png[m
[32m+     - assets/credit_card.png[m
[32m+ [m
[32m++ [m
  [m
    fonts:[m
      - family: San-Francisco-Pro-Fonts-master[m
