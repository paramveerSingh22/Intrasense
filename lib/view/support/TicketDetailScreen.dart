import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/res/component/CustomTextField.dart';

import '../../model/tickets/TicketDetailModel.dart';
import '../../model/user_model.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/UserManager.dart';
import '../../utils/Utils.dart';
import '../../view_models/ticket_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class TicketDetailScreen extends StatefulWidget {
  final dynamic ticketDetail;

  const TicketDetailScreen({Key? key, this.ticketDetail}) : super(key: key);

  @override
  _TicketDetailScreen createState() => _TicketDetailScreen();
}

class _TicketDetailScreen extends State<TicketDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    setState(() {});
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: 140.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
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
                  "Support",
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
            top: 110.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TabBar with a fixed height
                  PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'TICKET DETAILS'),
                        Tab(text: 'THREAD'),
                      ],
                      indicatorColor: AppColors.secondaryOrange,
                      labelColor: AppColors.secondaryOrange,
                      unselectedLabelColor: AppColors.textColor,
                    ),
                  ),
                  DividerColor(),
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FragmentTicketDetail(widget.ticketDetail),
                        FragmentChatScreen(widget.ticketDetail),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FragmentTicketDetail extends StatelessWidget {
  final dynamic ticketDetail; // Add this to receive ticketDetail

  const FragmentTicketDetail(this.ticketDetail, {Key? key}) : super(key: key);

  String getStatusText(String status) {
    switch (status) {
      case "1":
        return 'PENDING';
      case "2":
        return 'APPROVED';
      case "3":
        return 'CANCELED';
      case "4":
        return 'REJECTED';
      default:
        return 'INPROGRESS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = ticketDetail;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            // Wrap ListTile in a scrollable view
            child: Container(
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
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  bottom: 0,
                  top: 12,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        'Support Ticket No: ${item.ticketId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'First Name',
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
                              item.firstName,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Last Name',
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
                              item.lastName,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Organization',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.organisation,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.contactNo,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.emailId,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Designation',
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
                              item.designation,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Type of Issue',
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
                              item.issueType,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: const Text(
                                'Message',
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
                              item.ticketDescription,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                              getStatusText(item.status),
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
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FragmentChatScreen extends StatefulWidget {
  final dynamic ticketDetail;

  const FragmentChatScreen(this.ticketDetail, {Key? key}) : super(key: key);

  @override
  _FragmentChatScreen createState() => _FragmentChatScreen();
}

class _FragmentChatScreen extends State<FragmentChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UserModel? _userData;
  bool _isLoading = false;

  List<Comment> _messages = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    // Dispose the controller when not needed
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getTicketDetail() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'ticket_id': widget.ticketDetail.ticketId.toString(),
        'token': _userData?.token,
      };
      final ticketViewModel =
          Provider.of<TicketViewModel>(context, listen: false);
      final response = await ticketViewModel.getTicketDetailApi(data, context);
      setState(() {
        if (response != null) {
          _messages.clear;
          _messages = response.comments;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());
        }
      });

      Utils.hideLoadingDialog(context);
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching leaves list: $error');
    }
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  Future<void> getUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    // Fetching user data from UserManager singleton
    _userData = await UserManager().getUserData();

    if (kDebugMode) {
      print(_userData);
    }

    setState(() {
      _isLoading = false;
    });
    getTicketDetail();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              // This ensures the scroll position is at the bottom
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: isKeyboardVisible ? keyboardHeight : 0),
                // Adjust padding based on keyboard visibility
                child: ListView.builder(
                  controller: _scrollController,
                  // Attach the scroll controller
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  // Allow ListView to shrink to fit its content
                  itemBuilder: (context, index) {
                    var message = _messages[index];
                    if (message.senderId == _userData?.data?.userId) {
                      // For your own chat (User1), align the message to the right
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // Align the entire Row to the right
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // Align text to the right
                                children: [
                                  // Username
                                  Text(
                                    message.senderName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.black,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Message container with expanded space
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.comments,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          message.createdOn,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.hintColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Space between the message and image
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    "https://intrasense.co.uk/app/" +
                                        message.senderProfilePicture),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // For other users, align the message to the left
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // Align to the left
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  "https://intrasense.co.uk/app/" +
                                      message.senderProfilePicture),
                            ),
                            SizedBox(width: 10),
                            // Column for username and message
                            Expanded(
                              // Ensure the message container expands to take the available space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Align text to the left
                                children: [
                                  // Username
                                  Text(
                                    message.senderName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.black,
                                      fontFamily: 'PoppinsSemiBold',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Message container with expanded space
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryOrange
                                          .withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.comments,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        Text(
                                          message.createdOn,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.hintColor,
                                            fontFamily: 'PoppinsRegular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.grey,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Say Something...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    style: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 13.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: AppColors.secondaryOrange,
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      Map data = {
                        'user_id': _userData?.data?.userId.toString(),
                        'ticket_id': widget.ticketDetail.ticketId.toString(),
                        'ticket_reply': _messageController.text.toString(),
                        'sender_id': _userData?.data?.userId.toString(),
                        'token': _userData?.token.toString(),
                      };
                      Utils.showLoadingDialog(context);
                      final ticketViewModel =
                          Provider.of<TicketViewModel>(context, listen: false);
                      await ticketViewModel.addTicketCommentApi(data, context);
                      Utils.hideLoadingDialog(context);
                      _messageController.clear();
                      await getTicketDetail();
                      // After sending a message, scroll to the bottom
                      _scrollToBottom();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
