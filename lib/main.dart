import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasknexus/data/models/client_contact_model.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/data/models/school_data_model.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/models/user_model.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/auth_wrapper_screen.dart';
import 'package:tasknexus/features/home/bloc/bloc/add_task_bloc.dart';

//! ENTRY POINT
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INITIALIZE HIVE
  await Hive.initFlutter();
  //  await Hive.deleteFromDisk(); // Deletes all Hive data
  //  await Hive.deleteBoxFromDisk(UserModel.boxName);
  //   await Hive.deleteBoxFromDisk(TaskModel.boxName);
  //    await Hive.deleteBoxFromDisk(GeneralDataModel.boxName);

  // REGISTER HIVE ADAPTER
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ClientContactModelAdapter());
  Hive.registerAdapter(GeneralDataModelAdapter());
  Hive.registerAdapter(SchoolDataModelAdapter());

  runApp(const MyApp());
}

//! ROOT WIDGET
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //! BLOC PROVIDERS
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckUserLoggedIn())),
        BlocProvider(create: (context) => AddTaskBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        debugShowCheckedModeBanner: false,
        title: 'TASKNEXUS',
        // WRAPPER FOR CHECKING, USER LOGGED IN STATE
        home: AuthWrapperScreen(),
      ),
    );
  }
}
