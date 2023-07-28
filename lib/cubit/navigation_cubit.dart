import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  /// Index page:
  /// 0 -> home screen
  /// 1 -> order page
  /// 2 -> wallet page
  /// 3 -> mitra page
  /// 4 -> telphone page

  void setTabIndex(int index) {
    emit(index);
  }
}
