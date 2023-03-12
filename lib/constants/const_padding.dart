//where their Paddings are provided in the app

import 'package:flutter/rendering.dart';

class PagePadding extends EdgeInsets {
  //all
  const PagePadding.all0() : super.all(0);
  const PagePadding.all10() : super.all(10);
  const PagePadding.all16() : super.all(16);

  //symmetric
  const PagePadding.v40() : super.symmetric(vertical: 40);
  const PagePadding.h20() : super.symmetric(horizontal: 20);
  const PagePadding.h10() : super.symmetric(horizontal: 10);
  const PagePadding.v12() : super.symmetric(vertical: 12);
  const PagePadding.v20() : super.symmetric(vertical: 20);
  const PagePadding.h12v16() : super.symmetric(horizontal: 12, vertical: 16);

  //only
  const PagePadding.l8() : super.only(left: 8);
  const PagePadding.l16() : super.only(left: 16);
}
