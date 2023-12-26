import 'package:flutter/material.dart';
import 'dart:math';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
/// ho to use this class in textformfield
/// class ScaleSize {
//   static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
//     final width = MediaQuery.of(context).size.width;
//     double val = (width / 1400) * maxTextScaleFactor;
//     return max(1, min(val, maxTextScaleFactor));
//   }
// }


/// anther method to try it
///    class AdaptiveTextSize {
//       const AdaptiveTextSize();
//
//       getadaptiveTextSize(BuildContext context, dynamic value) {
//     // 720 is medium screen height
//         return (value / 720) * MediaQuery.of(context).size.height;
//       }
//     }
// use case :
//
//                  Text("Paras Arora",style: TextStyle(fontSize:
//                  AdaptiveTextSize().getadaptiveTextSize(context, 20)),