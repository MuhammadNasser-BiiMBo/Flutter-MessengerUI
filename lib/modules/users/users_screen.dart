import 'package:flutter/material.dart';

import '../../models/user/user_model.dart';

class UsersScreen extends StatelessWidget {
  
  List<UserModel> users=[
    UserModel(
        id: 1,
        name: 'Muhammad Nasser ',
        phone: '+201284371026',
    ),
    UserModel(
      id: 2,
      name: 'Hend Mostafa ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 1,
      name: 'Muhammad Nasser ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 2,
      name: 'Hend Mostafa ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 1,
      name: 'Muhammad Nasser ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 2,
      name: 'Hend Mostafa ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 1,
      name: 'Muhammad Nasser ',
      phone: '+201284371026',
    ),
    UserModel(
      id: 2,
      name: 'Hend Mostafa ',
      phone: '+201284371026',
    ),
  ];

  UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users'
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index)=>buildUserItem(users[index]),
          separatorBuilder: (context,index)=> Padding(
            padding: const EdgeInsetsDirectional.only(
                start:20
            ),
            child: Container(
              color: Colors.grey[400],
              width: double.infinity,
              height: 1,
            ),
          ),
          itemCount: users.length,
      ),
    );
  }

  Widget buildUserItem(UserModel user)=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children:  [
        CircleAvatar(
          radius: 30,
          child: Text(
            '${user.id}',
            style:const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              '${user.name}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${user.phone}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),

      ],
    ),
  );
  //1 -Build Item
  // 2- Build List
  //3-Add Item to list
}

