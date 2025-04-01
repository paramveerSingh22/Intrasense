import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/network/app_url.dart';
import '../../model/notification/NotificationListModel.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class NotificationDetailScreen extends StatefulWidget{
  final NotificationListModel notificationDetail;
  const NotificationDetailScreen({super.key, required this.notificationDetail});

  @override
  _NotificationDetailScreen createState() => _NotificationDetailScreen();
}

class _NotificationDetailScreen extends State<NotificationDetailScreen>{
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
                 "Notifications",
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
           bottom: 10.0,
           child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: const Align(
                           alignment: Alignment.centerLeft,
                           child: Text(
                             "Notification Details",
                             style: TextStyle(
                                 fontSize: 14,
                                 color: AppColors.secondaryOrange,
                                 fontFamily: 'PoppinsMedium'),
                           ))),

                   const SizedBox(height: 10),

                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                     child: Container(
                       child: ListTile(
                         contentPadding: const EdgeInsets.only(
                           bottom: 0,
                           top: 0,
                         ),
                         title: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(left: 10.0, right: 10),
                               child:Column(
                                 children: [
                                   Row(
                                     children: [
                                       CircleAvatar(
                                         radius: 30,
                                         backgroundColor: Colors.grey[300],
                                         backgroundImage: widget.notificationDetail.profilePicture != null
                                             ? NetworkImage(AppUrl.imageUrl +  widget.notificationDetail.profilePicture.toString())
                                             : AssetImage(Images.profileIcon) as ImageProvider,
                                       ),
                                       const SizedBox(width: 10),
                                       Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               "${widget.notificationDetail.senderFirstname} ${widget.notificationDetail.senderLastname}",
                                               style: const TextStyle(
                                                 fontSize: 16,
                                                 color: AppColors.black,
                                                 fontWeight: FontWeight.w500,
                                                 fontFamily: 'PoppinsMedium',
                                               ),
                                             ),
                                             const SizedBox(height: 5),
                                             Text(
                                               widget.notificationDetail.datetime.toString(),
                                               style: const TextStyle(
                                                 fontSize: 12,
                                                 color: AppColors.hintColor,
                                                 fontWeight: FontWeight.w400,
                                                 fontFamily: 'PoppinsRegular',
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                       // Spacer pushes the delete icon to the top-right corner
                                     ],
                                   ),
                                   const SizedBox(height: 10),
                                   Align(
                                     alignment: Alignment.topLeft,
                                     child: Text(
                                       widget.notificationDetail.notificationMessage.toString(),
                                       style: const TextStyle(
                                         fontSize: 14,
                                         color: AppColors.textColor,
                                         fontWeight: FontWeight.w500,
                                         fontFamily: 'PoppinsMedium',
                                       ),
                                     ),
                                   )
                                 ],
                               )
                             )
                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
               )),
         ),
       ],
     ),
   );
  }
}