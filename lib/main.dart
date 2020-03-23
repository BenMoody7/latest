import 'package:flutter/material.dart';
import 'package:flutter_app/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /*Map<int, Color> color ={50:Color.fromRGBO(89,9,14, .1),100:Color.fromRGBO(89,9,14, .2),200:Color.fromRGBO(89,9,14, .3),300:Color.fromRGBO(89,9,14, .4),400:Color.fromRGBO(89,9,14, .5),500:Color.fromRGBO(89,9,14, .6),600:Color.fromRGBO(89,9,14, .7),700:Color.fromRGBO(89,9,14, .8),800:Color.fromRGBO(89,9,14, .9),900:Color.fromRGBO(89,9,14, 1),};
*/
  @override
  Widget build(BuildContext context) {
    //MaterialColor colorCustom = MaterialColor(0xffe31825, color);
    return MaterialApp(



      theme: ThemeData(
          primarySwatch: Colors.red,//bottomAppBarColor: colorCustom
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
