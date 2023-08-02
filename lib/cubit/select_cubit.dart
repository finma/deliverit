import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCubit extends Cubit<dynamic> {
  SelectCubit(dynamic initialValue) : super(null);

  void setSelectedValue(dynamic value) {
    emit(value);
  }
}
