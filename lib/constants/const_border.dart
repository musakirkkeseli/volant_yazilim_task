//where their BorderRadius are provided in the app

import 'package:flutter/rendering.dart';

class CustomBR extends BorderRadius {
  const CustomBR.all20() : super.all(const Radius.circular(20));
  const CustomBR.all15() : super.all(const Radius.circular(15));
}
