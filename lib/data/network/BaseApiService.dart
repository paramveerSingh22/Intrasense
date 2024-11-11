import 'package:flutter/src/widgets/framework.dart';

abstract class BaseApiService{

  Future<dynamic> getGetApiResponse(String url, BuildContext context);

  Future<dynamic> getPostApiResponse(String url, dynamic data,BuildContext context);

  Future<dynamic> getPostWithFileApiResponse(String url, dynamic data,BuildContext context, String? filePath);
}