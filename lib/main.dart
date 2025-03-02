import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasknexus/data/models/user_model.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/auth_wrapper_screen.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';

//! ENTRY POINT
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INITIALIZE HIVE
  await Hive.initFlutter();

  // REGISTER HIVE ADAPTER
  Hive.registerAdapter(UserModelAdapter());

  runApp(const MyApp());
}

//! ROOT WIDGET
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthBloc()..add(CheckUserLoggedIn()))],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        debugShowCheckedModeBanner: false,
        title: 'TASKNEXUS',
        home: AuthWrapperScreen()
      ),
    );
  }
}
