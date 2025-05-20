import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/documents/FileDetailResponse.dart';
import 'package:intrasense/utils/Images.dart';
import 'package:provider/provider.dart';
import '../../data/network/app_url.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../../view_models/documents_view_model.dart';
import '../../view_models/user_view_model.dart';

class FileDetailsScreen {
  static UserModel? _userData;

  static Future<UserModel> getUserData() => UserViewModel().getUser();

  static void show(BuildContext context, String? id) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getFileDetailApi(context,id);
  }

  static void getFileDetailApi(BuildContext context, String? id) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        'deviceToken': Constants.deviceToken,
        'deviceType': Constants.deviceType,
        'pId': id,
        'token': _userData?.token,
      };

      final documentViewModel = Provider.of<DocumentsViewModel>(context, listen: false);
      final response = await documentViewModel.getFileDetailApi(data, context);

      Utils.hideLoadingDialog(context);
      Future.delayed(Duration(milliseconds: 100), () {
        if (context.mounted) {
          showDialogBox(context,response);
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load my files list')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }

  static void showDialogBox(BuildContext context, FileDetailResponse? response) {
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
              heightFactor: 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      color: AppColors.secondaryOrange.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                            icon: const Icon(Icons.close, color: AppColors.textColor),
                            onPressed: () => Navigator.pop(context),
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
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => isDetailSelected = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.skyBlueTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: isDetailSelected
                                        ? AppColors.secondaryOrange
                                        : AppColors.dividerColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: const Text("DETAIL"),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => isDetailSelected = false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.skyBlueTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: !isDetailSelected
                                        ? AppColors.secondaryOrange
                                        : AppColors.dividerColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: const Text("ACTIVITY"),
                            ),
                          )
                        ],
                      ),
                    ),

                    if (isDetailSelected)...{
                      ..._buildDetailSection(response)}
                    else...{
                      ..._buildActivitySection(response?.history),
                      Container(
                        color: AppColors.secondaryOrange.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Images.shareIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 10.0,),

                                const Text(
                                  'Shared with:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                )
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.textColor),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: response?.sharedWith?.length??0,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = response?.sharedWith?[index];
                            return CustomShareFileListTile( item: item);

                          } ,
                        ),
                      ),
                    }

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static List<Widget> _buildDetailSection(FileDetailResponse? response) {
    return [
      const SizedBox(height: 20),
      _infoRow("Type:", response?.type == "1" ? "Folder" : "File"),
      _infoRow("Location:", response?.location.toString()??""),
      _infoRow("Owner:", response?.ownerName.toString()??""),
      _infoRow(
          "Last Modified:",
          (response?.history != null && response?.history?.isNotEmpty==true)
              ? response?.history?.first.date ?? "-"
              : "-"
      ),

      Container(
        color: AppColors.secondaryOrange.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  Images.shareIcon,
                  height: 20,
                  width: 20,
                ),
                SizedBox(width: 10.0,),

                const Text(
                  'Shared with:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsRegular',
                  ),
                )
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.textColor),
              onPressed: () {},
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 200,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: response?.sharedWith?.length??0,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = response?.sharedWith?[index];
            return CustomShareFileListTile( item: item);

    } ,
        ),
      ),
    ];
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
              fontFamily: 'PoppinsMedium',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontFamily: 'PoppinsRegular',
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _buildActivitySection(List<HistoryItem>? history) {
    if (history == null || history.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No activity available.",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColor,
              fontFamily: 'PoppinsRegular',
            ),
          ),
        )
      ];
    }

    List<Widget> activityWidgets = [];
    for (var item in history) {
      activityWidgets.add(_activityItem(
        item.date ?? "-",
        item.action ?? "-",
        item.targetUserName ?? (item.toName?.isNotEmpty == true ? item.toName! : "-"),
      ));
      activityWidgets.add(const Divider());
    }

    // Optionally add bottom divider
    activityWidgets.add(const DividerColor());

    return activityWidgets;
  }

  static Widget _activityItem(String date, String action, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Align(
        alignment: Alignment.centerLeft, // Force align left
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ensure left-align
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontFamily: 'PoppinsMedium',
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontFamily: 'PoppinsRegular',
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                fontFamily: 'PoppinsRegular',
              ),
            ),
          ],
        ),
      ),
    );
  }


}


class CustomShareFileListTile extends StatelessWidget {

  final SharedUser? item;

  const CustomShareFileListTile(
      {super.key, required this.item});

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
                      radius: 23,
                      backgroundImage: NetworkImage(
                          AppUrl.imageUrl + (item?.image.toString() ?? "")),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item?.name??"",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsMedium',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
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
