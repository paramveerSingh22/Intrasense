import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class UploadFileScreen {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool isDetailSelected = true;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              /*heightFactor: 0.8,*/
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      color: AppColors.secondaryOrange.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upload File',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            color: AppColors.lightBlue,
                            border: Border.all(
                              color: AppColors.lightBlue,
                              width: 1.0,
                            ),
                          ),
                          height: 80,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Row(children: [
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Image.asset(
                                    Images.uploadIcon,
                                    height: 50,
                                    width: 50,
                                  ),
                                  onPressed: () {
                                    // pickFile();
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'UPLOAD FILE',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.skyBlueTextColor,
                                              fontFamily: 'PoppinsMedium'),
                                        ),
                                        Text(
                                          'Add upto 25 mb',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textColor,
                                              fontFamily: 'PoppinsRegular',
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ))
                              ]))),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: CustomElevatedButton(
                        onPressed: () async {},
                        buttonText: 'UPLOAD FILE',
                        //loading: expenseViewModel.loading,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
