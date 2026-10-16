import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cityu_cover_page/app.dart';
import 'package:cityu_cover_page/presentation/cubit/save_as_image_selection_cubit.dart';
import 'package:cityu_cover_page/presentation/cubit/template_selection_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TemplateSelectionCubit()),
        BlocProvider(create: (_) => SaveAsImageSelectionCubit()),
      ],
      child: const MyApp(),
    ),
  );
}
