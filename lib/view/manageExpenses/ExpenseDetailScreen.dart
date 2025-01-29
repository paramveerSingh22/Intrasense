import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/expense_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../Home/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final dynamic expenseDetail;

  const ExpenseDetailScreen({Key? key, this.expenseDetail}) : super(key: key);

  @override
  _ExpenseDetailScreen createState() => _ExpenseDetailScreen();
}

class _ExpenseDetailScreen extends State<ExpenseDetailScreen> {
  String? selectExpenseStatusValue;
  UserModel? _userData;
  bool _isLoading = false;
  final TextEditingController _approvalDesController = TextEditingController();

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void showDocumentDialog(BuildContext context) {
    final url = "https://intrasense.co.uk/app/" +
        widget.expenseDetail.expenseReceipt.replaceAll(r'\', '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attachment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Failed to load document.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void openCommentPopUp(String expenseStatus) {
    final expenseViewModel =
        Provider.of<ExpenseViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Comment',
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
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: CustomTextField(
                    controller: _approvalDesController,
                    hintText: 'Description',
                    minLines: 4,
                    maxLines: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (_approvalDesController.text.toString().isEmpty) {
                        Utils.toastMessage("Please add comments");
                      } else {
                        Navigator.pop(context, true);
                        Utils.showLoadingDialog(context);
                        Map data = {
                          'user_id': _userData?.data?.userId.toString(),
                          'usr_role_track_id':
                              _userData?.data?.roleTrackId.toString(),
                          'expense_id':
                              widget.expenseDetail.expenseId.toString(),
                          'sender_id': widget.expenseDetail.userId,
                          'token': _userData?.token.toString(),
                          if (expenseStatus.toString().toLowerCase() ==
                              "paid") ...{
                            'paid_description':
                                _approvalDesController.text.toString(),
                          } else ...{
                            'approval_status': expenseStatus,
                            'approval_description':
                                _approvalDesController.text.toString(),
                          }
                        };
                        if (expenseStatus.toString().toLowerCase() == "paid") {
                          await expenseViewModel.paidExpenseApi(data, context);
                        } else {
                          await expenseViewModel.approveExpenseApi(
                              data, context);
                        }

                        Utils.hideLoadingDialog(context);
                        Navigator.pop(context, true);
                      }
                    },
                    buttonText: 'SUBMIT',
                    loading: expenseViewModel.loading,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'PENDING';
        case "2":
          return 'APPROVED';
        case "3":
          return 'PAID';
        case "4":
          return 'REJECTED';
        default:
          return 'PENDING';
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              Images.curveBg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expense Detail',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 60,
            // Adjust the bottom to leave space for the button
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Expense Detail',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryOrange,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.dividerColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Transform.translate(
                                offset: const Offset(0, -10), // This will move the content up by 10 dp
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IgnorePointer(
                                        ignoring: true,
                                        child: Container(
                                          width: double.infinity, // Set width to match parent
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryOrange.withOpacity(0.1),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20), // Adjusted padding
                                            child: Text(
                                              widget.expenseDetail.expenseTitle,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primaryColor,
                                                fontFamily: 'PoppinsRegular',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Raised by',
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
                                                widget.expenseDetail.usrName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
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
                                                widget.expenseDetail.expenseForDate != null
                                                    ? DateFormat('yyyy-MM-dd').format(widget.expenseDetail.expenseForDate!)
                                                    : DateFormat('yyyy-MM-dd').format(widget.expenseDetail.createdOn),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Category',
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
                                                widget.expenseDetail.expenseCategory,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Amount',
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
                                                widget.expenseDetail.amount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Attachment',
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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Transform.translate(
                                                    offset: const Offset(-10.0, 0.0),
                                                    child: IconButton(
                                                      icon: SizedBox(
                                                        height: 20.0,
                                                        width: 20.0,
                                                        child: Image.asset(Images.eyeIcon),
                                                      ),
                                                      onPressed: () async {
                                                        showDocumentDialog(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: const Text(
                                                  'Status',
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
                                                getStatusText(widget.expenseDetail.status),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primaryColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const DividerColor(),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    child: const Text(
                                                      'Description',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.textColor,
                                                        fontFamily: 'PoppinsRegular',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                widget.expenseDetail.expenseDescription,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_userData?.data?.roleTrackId.toString() == "3" &&
                            widget.expenseDetail.status.toString() == "1") ...{
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Expense status',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsMedium'),
                                    )),
                                const SizedBox(height: 5),
                                CustomDropdown(
                                  value: selectExpenseStatusValue,
                                  items: ["Approved", "Rejected", "Paid"],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectExpenseStatusValue = newValue;
                                    });
                                  },
                                  hint: 'Expense status',
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          )
                        }
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_userData?.data?.roleTrackId.toString() == "3" &&
              widget.expenseDetail.status.toString() == "1") ...{
            Positioned(
              left: 0,
              right: 0,
              bottom: 0, // Position button at the bottom of the screen
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: CustomElevatedButton(
                    onPressed: () {
                      if (selectExpenseStatusValue == null) {
                        Utils.toastMessage("Please select expense status");
                        return;
                      } else {
                        openCommentPopUp(selectExpenseStatusValue.toString());
                      }
                    },
                    buttonText: 'SUBMIT',
                    loading: expenseViewModel.loading),
              ),
            )
          },
        ],
      ),
    );
  }
}
