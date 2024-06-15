import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext{

  ///
  /// gets the devices size params
  ///
  Size getDeviceSize(){
    return MediaQuery.of(this).size;
  }

  ///
  /// gets the devices screen width
  ///
  double getDeviceWidth(){
    return getDeviceSize().width;
  }

  ///
  /// gets the devices screen height
  ///
  double getDeviceHeight(){
    return getDeviceSize().height;
  }

}