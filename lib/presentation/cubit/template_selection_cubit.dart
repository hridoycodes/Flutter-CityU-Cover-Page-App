import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateSelectionCubit extends Cubit<int> {
  TemplateSelectionCubit() : super(0);

  void selectTemplate(int id) {
    emit(id);
  }
}
