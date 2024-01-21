import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_test_app/res/add_employee_screen.dart';
import 'package:real_time_test_app/res/home_screen.dart';
import 'package:real_time_test_app/res/update_delete_screen.dart';
import 'package:real_time_test_app/src/data/employee_repository.dart';
import 'package:real_time_test_app/src/operations/employee_cubit.dart';
import 'package:sqflite/sqflite.dart';

import 'Utils/color.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  final EmployeeRepository repository = EmployeeRepository();
  await repository.initializeDatabase();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final EmployeeRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primary,
          useMaterial3: true,
          backgroundColor: backGround,
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
              backgroundColor: primary,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black.withOpacity(0.2))),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primary,
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),iconSize: 24,elevation: 0)
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeCubit>(
            create: (context) => EmployeeCubit(repository),
          ),
        ],
        child: HomeScreen(repository: EmployeeCubit(repository)),
      ),

    );
  }
}
