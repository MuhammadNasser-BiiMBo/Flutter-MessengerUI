import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:new_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required VoidCallback function,
  required String text,
  bool isUpperCase = true,
  double radius = 0,
}) =>
    Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
        ),
        height: 50,
        width: width,
        child: MaterialButton(
            onPressed: function,
            child: Text(
              isUpperCase ? text.toUpperCase() : text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )));

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function onSubmit,
  required VoidCallback onTap,
  required Function onChange,
  required String label,
  required IconData prefix,
  required String? Function(dynamic value) validate,
  bool isPassword = false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      // onFieldSubmitted: onSubmit(),
      // onChanged: onChange(),
      validator: validate,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  icon: Icon(suffix),
                  onPressed: suffixPressed,
                )
              : null,
          border: const OutlineInputBorder()),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Archived', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => mySeparator(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please add some tasks',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      )),
    );


Widget mySeparator() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey,
      ),
    );


void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
