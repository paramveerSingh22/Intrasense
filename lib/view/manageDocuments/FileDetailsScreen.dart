import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';

class FileDetailsScreen {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        bool isDetailSelected = true; // Move outside of builder

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    color: AppColors.secondaryOrange.withOpacity(0.1),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Toggle Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        IntrinsicWidth(
                          child: Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isDetailSelected = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.skyBlueTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: isDetailSelected
                                        ? AppColors.secondaryOrange
                                        : AppColors.dividerColor,
                                    // dynamic border color
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: const Text("DETAIL"),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isDetailSelected = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.skyBlueTextColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                      color: !isDetailSelected
                                          ? AppColors.secondaryOrange
                                          : AppColors.dividerColor,
                                      // dynamic border color
                                      width: 0.5,
                                    )),
                              ),
                              child: const Text("ACTIVITY"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Type:",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontFamily: 'PoppinsMedium',
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Folder",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Location:",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontFamily: 'PoppinsMedium',
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "My Folder",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Owner:",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontFamily: 'PoppinsMedium',
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Aman",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      children: [
                        Text(
                          "Last Modified:",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontFamily: 'PoppinsMedium',
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "22 feb, 2022",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    color: AppColors.secondaryOrange.withOpacity(0.1),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shared with:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.textColor,
                            ),
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200, // or MediaQuery height fraction
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemCount: 2,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return CustomShareFileListTile();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomShareFileListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                bottom: 0,
                top: 0,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://image.flaticon.com/icons/png/512/216221/216221541.png"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "aman.singh@gmail.com",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  DividerColor()
                ],
              ),
            ),
        ),
      ],
    );
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.dividerColor,
      height: 0.5,
    );
  }
}
