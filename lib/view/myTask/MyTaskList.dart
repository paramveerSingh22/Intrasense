import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/res/component/CustomElevatedButton.dart';
import 'package:intrasense/view/myTask/CreateTask.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class MyTaskList extends StatefulWidget {
  const MyTaskList({super.key});

  @override
  _MyTaskList createState() => _MyTaskList();
}

class _MyTaskList extends State<MyTaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Positioned(
              top: 30.0,
              // Adjust this value as needed
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(12.0, 5.0, 50.0, 5.0),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 0.0),
                                      child: Text(
                                        'My Task List ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.secondaryOrange,
                                            fontFamily: 'PoppinsMedium'),
                                      ))),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    underline: Container(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    items: <String>[
                                      'Option 1',
                                      'Option 2',
                                      'Option 3',
                                      'Option 4'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {},
                                    hint: const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text('Select an option'),
                                    ),
                                    isExpanded: true,
                                  ),
                                ),
                              )
                            ],
                          )),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                            color: AppColors.lightBlue,

                            child: ListView.separated(
                              itemCount: 5,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                    height:
                                    10); // List items ke beech mein 10 dp ka gap
                              },
                              itemBuilder: (context, index) {
                                return CustomMyTaskListTile();
                              },
                            )),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTask(),
                              ),
                            );
                          },
                          buttonText: 'Create Task',
                        ),
                      )
                    ],
                  )),
            ),
          ]
      ),
    );
  }
}

class CustomMyTaskListTile extends StatelessWidget {
  const CustomMyTaskListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Colors.white, // White color set kiya gaya hai
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '[MINMLI2002181-ADE]',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontFamily: 'PoppinsRegular'),
            ),
            Text(
              'Dusshera EDM',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontFamily: 'PoppinsRegular')
              ,
            ),
            SizedBox(height: 10), // Padding between Text and TextFields
            Row(
              children: [
                Container(
                    width: 100,
                    child: Text(
                      'Client',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,),
                    )),
                Text(
                  'Shapoorji',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                      fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.w500,),
                )
              ],
            ),
            const SizedBox(height: 10),
            const DividerColor(),
            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                    width: 100,
                    child: Text(
                      'Project',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,),
                    )),
                Text(
                  'Virar',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.w500,),
                )
              ],
            ),
            const SizedBox(height: 10),
            const DividerColor(),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                    width: 100,
                    child: Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,),
                    )),
                Text(
                  '17/02/2022',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.w500,),
                )
              ],
            ),
            const SizedBox(height: 10),
            const DividerColor(),
            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                    width: 100,
                    child: Text(
                      'Due Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,),
                    )),
                Text(
                  '27/02/2022',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.w500,),
                )
              ],
            ),

            const SizedBox(height: 10),
            const DividerColor(),
            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                    width: 100,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular',
                        fontWeight: FontWeight.w400,),
                    )),
                Text(
                  'ON HOLD',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryOrange,
                    fontFamily: 'PoppinsRegular',
                    fontWeight: FontWeight.w500,),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.grey,
      height: 0.5,
    );
  }
}
