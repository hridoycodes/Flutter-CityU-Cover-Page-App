import 'package:flutter_bloc/flutter_bloc.dart';

class SaveAsImageSelectionCubit extends Cubit<bool> {
  SaveAsImageSelectionCubit() : super(false);

  void toggle() => emit(!state);
}
