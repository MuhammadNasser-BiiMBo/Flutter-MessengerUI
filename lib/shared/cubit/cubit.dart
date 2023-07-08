import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/shared/cubit/states.dart';
import 'package:new_app/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
import '../network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Future<String> getName() async {
    return 'Muhammad Nasser';
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    return await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")'
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error while inserting new record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks=[];
    archivedTasks=[];
    doneTasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
        {
          newTasks.add(element);
        }
        else if (element['status'] == 'Done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'Delete FROM tasks WHERE id = ?',
        [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isDark=false;
  void changeAppMode({bool? fromShared})
  {
    if(fromShared != null) {
      isDark=fromShared;
      emit(AppChangeModeState());
    }
    else
    {
      isDark=!isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
      {
        emit(AppChangeModeState());
      });
    }
  }
}