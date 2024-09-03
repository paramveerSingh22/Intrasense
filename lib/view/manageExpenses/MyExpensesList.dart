import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class MyExpenseList extends StatefulWidget{
  @override
  _MyExpenseList createState() => _MyExpenseList();


}
class _MyExpenseList extends State<MyExpenseList>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20.0,
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
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      'Expenses List',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsMedium'),
                                    ))),
                          ],
                        )),
                    SizedBox(height: 20),
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
                              return CustomExpenseListTile();
                            },
                          )),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

}

class CustomExpenseListTile extends StatelessWidget {
  const CustomExpenseListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        'Travel Report',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Image.asset(
                            Images.editIcon,
                            width: 20.0,
                            height: 20.0, // Update with your asset path
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            Images.deleteIcon,
                            width: 20.0,
                            height: 20.0, // Update with your asset path
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            Images.threeDotsRed,
                            width: 12.0,
                            height: 20.0, // Update with your asset path
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '22 Feb 2022',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                    ),),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Mostrud exercitation by ullamco laboris nisi nostrud lorem ipsum.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                        child: Container(
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                    ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Travel',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "100",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'IN PROGRESS',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}