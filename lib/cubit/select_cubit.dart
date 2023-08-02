import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCubit extends Cubit<dynamic> {
  SelectCubit(dynamic initialValue) : super(initialValue);

  void setSelectedValue(dynamic value) {
    emit(value);
  }
}
