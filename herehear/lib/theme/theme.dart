import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// final ThemeData light_theme = buildClosetTheme_light();
// final ThemeData dark_theme = buildClosetTheme_dark();

final ThemeData lightTheme = buildClosetThemeLight();
final ThemeData darkTheme = buildClosetThemeDark();

ThemeData buildClosetThemeLight() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: ColorScheme(
      primary: PrimaryColorLight,
      primaryVariant: PrimaryVariantLight,
      secondary: SecondaryLight,
      secondaryVariant: SecondaryVariantLight,
      surface: SurfaceLight,
      background: BackgroundLight,
      error: ErrorLight,
      onPrimary: OnPrimaryLight,
      onSecondary: OnSecondaryLight,
      onSurface: OnSurfaceLight,
      onBackground: OnBackgroundLight,
      onError: OnErrorLight,
      brightness: Brightness.light,
    ),
    appBarTheme: base.appBarTheme.copyWith(
      iconTheme: IconThemeData(color: OnBackgroundLight),
      color: BackgroundLight,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: OnBackgroundLight,
        fontFamily: 'Noto Sans CJK kr-medium',
        fontWeight: FontWeight.w500,
        fontSize: 17.sp,
        // height: 38.26,
      ),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(

    ),
    scaffoldBackgroundColor: BackgroundLight,
    cardColor: SurfaceLight,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: OnSecondaryLight,
      colorScheme: base.colorScheme.copyWith(
        primary: SurfaceLight,
        secondary: SurfaceLight,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),

    textTheme: _buildClosetTextTheme(base.textTheme),
    primaryTextTheme: _buildClosetTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildClosetTextTheme(base.accentTextTheme),
  );

}
// ThemeData light = ThemeData(
//
// );
// ThemeData light = ThemeData(
//     // brightness: Brightness.light,
//     brightness: Brightness.light,
//     // primaryColorLight: Color(0xff6200EE),
//     primarySwatch: Colors.white,
//     accentColor: Colors.pink,
//     scaffoldBackgroundColor: Color(0xfff1f1f1));
// // scaffoldBackgroundColor: Color(0xff6200EE));

ThemeData buildClosetThemeDark() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    colorScheme: ColorScheme(
      primary: PrimaryColorDark,
      primaryVariant: PrimaryVariantDark,
      secondary: SecondaryDark,
      secondaryVariant: SecondaryVariantDark,
      surface: SurfaceDark,
      background: BackgroundDark,
      error: ErrorDark,
      onPrimary: OnPrimaryDark,
      onSecondary: OnSecondaryDark,
      onSurface: OnSurfaceDark,
      onBackground: OnBackgroundDark,
      onError: OnErrorDark,
      brightness: Brightness.dark,
    ),
    // const PrimaryColorDark = Color(0xFFBB86FC);
    // const PrimaryVariantDark = Color(0xFF3700B3);
    // const SecondaryDark = Color(0xFF03DAC6);
    // const SecondaryVariantDark = Color(0xFF03DAC6);
    // const BackgroundDark = Color(0xFF121212);
    // const SurfaceDark = Color(0xFF121212);
    // const ErrorDark = Color(0xFFCF6679);
    // const OnPrimaryDark = Color(0xFF000000);
    // const OnSecondaryDark = Color(0xFF000000);
    // const OnBackgroundDark = Color(0xFFFFFFFF);
    // const OnSurfaceDark = Color(0xFFFFFFFF);
    // const OnErrorDark = Color(0xFF000000);
    appBarTheme: base.appBarTheme.copyWith(
      color: BackgroundDark,
      titleTextStyle: TextStyle(color: OnBackgroundDark),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(

    ),
    scaffoldBackgroundColor: SurfaceDark,
    cardColor: BackgroundDark,      // <--- ?????? ??? ?????? ????????? ??????????????? ??????!!!!!!!!!!!!
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: OnSecondaryDark,
      colorScheme: base.colorScheme.copyWith(
        primary: SurfaceDark,
        secondary: OnSecondaryDark,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),

    textTheme: _buildClosetTextTheme(base.textTheme).copyWith(
      // displayColor: OnSecondaryDark,
    ),
    primaryTextTheme: _buildClosetTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildClosetTextTheme(base.accentTextTheme),
  );
}




// ThemeData dark = ThemeData(
//     brightness: Brightness.dark,
//     primarySwatch: Colors.indigo,
//     accentColor: Colors.pink,
//     scaffoldBackgroundColor: Color(0xfff1f1f1));

class ThemeController extends GetxController {
  // final String key = "theme";
  RxBool isDarkTheme = false.obs;

  ThemeController() {
    isDarkTheme.value = false;
  }
  toggleTheme() {
    isDarkTheme.value = !(isDarkTheme.value);
    update();
  }
}

TextTheme _buildClosetTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline1: base.headline1!.copyWith(
      color: OnBackgroundLight,
      fontSize: 19.sp,
      fontFamily: 'Noto Sans CJK kr-bold',
      fontWeight: FontWeight.bold,
    ),
    headline2: base.headline2!.copyWith(
      color: OnBackgroundLight,
      fontSize: 19.sp,
      fontFamily: 'Noto Sans CJK kr-medium',
      fontWeight: FontWeight.w500,
    ),
    headline3: base.headline3!.copyWith(
      color: OnBackgroundLight,
      fontSize: 19.sp,
      fontFamily: 'Noto Sans CJK kr-regular',
      fontWeight: FontWeight.normal,
    ),
    headline4: base.headline4!.copyWith(
      color: OnBackgroundLight,
      fontSize: 14.sp,
      fontFamily: 'Noto Sans CJK kr-bold',
      fontWeight: FontWeight.bold,
    ),
    headline5: base.headline5!.copyWith(
      fontSize: 14.0.sp,
      fontFamily: 'Noto Sans CJK kr-regular',
      fontWeight: FontWeight.normal,
    ),
    headline6: base.headline6!.copyWith(
      fontSize: 12.0.sp,
      fontFamily: 'Noto Sans CJK kr-regular',
      fontWeight: FontWeight.normal,
    ),
    subtitle1: base.subtitle1!.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 14.0.sp,
      fontFamily: 'Noto Sans CJK kr-regular',
    ),
    subtitle2: base.subtitle2!.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 11.0.sp,
      fontFamily: 'Noto Sans CJK kr-bold',
    ),
    bodyText1: base.bodyText1!.copyWith(
      fontWeight: FontWeight.w200,
      color: OnSurfaceLight,
      fontSize: 11.0.sp,
      fontFamily: 'Noto Sans-extraLight',
    ),
    caption: base.caption!.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 24.0.sp,
      fontFamily: 'Noto Sans CJK KR-regular',
    ),
  );
}

AppBarTheme buildClosetAppBarTheme(AppBarTheme base) {
  return base.copyWith(
    centerTitle: false,
    titleTextStyle: base.titleTextStyle!.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Sansita',
    ),

  );
}