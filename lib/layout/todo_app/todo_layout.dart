import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:new_app/shared/components/components.dart';
import 'package:new_app/shared/cubit/cubit.dart';
import 'package:new_app/shared/cubit/states.dart';

// 1.Create database
// 2.Create Tables
// 3.open the database
// 4.insert to the Database
// 5.get from database
// 6.update the database
//  7.delete from the database

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);
  //variables
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer< AppCubit, AppStates>(
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertDatabaseState) {Navigator.pop(context);}
        },
        builder: (BuildContext context,AppStates state){
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: state is!AppGetDatabaseLoadingState? cubit.screens[cubit.currentIndex]:const Center(child: CircularProgressIndicator()) ,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet((context) => Container (
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            onSubmit: (){},
                            label: 'Task Title',
                            prefix: Icons.title,
                            validate: (value)
                            {
                              if(value.isEmpty){
                                return 'Title Must not be empty';
                              }
                            }, onTap: (){}, onChange: (){},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            onSubmit: (){},
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                            validate: (value)
                            {
                              if(value.isEmpty){
                                return 'Time Must not be empty';
                              }
                            },
                            onTap: ()
                            {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value){
                                timeController.text=value!.format(context).toString();
                              });
                            }, onChange: (){},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            onSubmit: (){},
                            label: 'Task date',
                            prefix: Icons.calendar_today_outlined,
                            validate: (value)
                            {
                              if(value.isEmpty){
                                return 'Date Must not be empty';
                              }
                            },
                            onTap: ()
                            {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:  DateTime.now(),
                                lastDate: DateTime.parse('2025-01-01'),
                              ).then((value)
                              {
                                dateController.text=DateFormat.yMMMd().format(value!);
                              });
                            }, onChange: (){},
                          ),
                        ],
                      ),
                    ),
                  ),
                    elevation: 20,
                  ).closed.then((value) //34an my7sl4 ele error ele 7sl lma bn2fl el bottom sheet b2dena
                  {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add
                  );
                }},
              child:  Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.grey[300],
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}




