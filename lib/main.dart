import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/layout/todo_app/todo_layout.dart';
import 'package:new_app/shared/bloc_observer.dart';
import 'package:new_app/shared/cubit/cubit.dart';
import 'package:new_app/shared/cubit/states.dart';
import 'package:new_app/shared/network/local/cache_helper.dart';
import 'package:new_app/shared/network/remote/dio_helper.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder:(context,state)=>  MaterialApp(
          debugShowCheckedModeBanner: false,
          home:   HomeLayout(),
        ),
      ),
    );
  }
}
