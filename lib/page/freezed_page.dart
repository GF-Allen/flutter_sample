import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sample/model/base_response.dart';
import 'package:flutter_sample/model/user_info.dart';

class FreezedPage extends StatefulWidget {
  const FreezedPage({super.key});

  @override
  State<FreezedPage> createState() => _FreezedPageState();
}

class _FreezedPageState extends State<FreezedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Freezed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                String json = '''
                {
    "code":"code",
    "message":"messgae"
    
}
                 ''';
                BaseResponse<UserInfo> resp = BaseResponse.fromJson(jsonDecode(json), (p0) => UserInfo.fromJson(p0 as Map<String, dynamic>));
                print('${resp.data?.avatar}');
              },
              child: const Text('object'),
            ),
            TextButton(
              onPressed: () {
                String json = ''' 
                {
    "code":"code",
    "message":"messgae"
   
}               
                ''';
                BaseResponse<List<UserInfo>> resp = BaseResponse.fromJson(
                    jsonDecode(json),
                    (p0) => (p0 as List)
                            .map(
                              (e) => UserInfo.fromJson(e as Map<String, dynamic>),
                            )
                            .toList());
                print('$resp');
              },
              child: const Text('list'),
            ),
          ],
        ),
      ),
    );
  }
}
