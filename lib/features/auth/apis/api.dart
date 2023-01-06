import  'dart:convert';
import 'dart:io';
import 'package:corncall/models/user_model.dart';
import 'package:firebase_auth_platform_interface/src/providers/phone_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthApi {
  var userId = '';
  static const baseUrl = 'https://corncall.com:2087/';
  static Future<UserModel> getUserInfo(userId) async {
    final response = await http.post(Uri.parse(baseUrl + ""),body: {'id':userId});
    if(response.statusCode == 200)
    {
      // var data = jsonDecode(response.body);
      // print(data['responseValue'][0]);
      // var id = data['responseValue'][0]['verificationID'];
      // print(id);
      // codeSent(id.toString(),0);
      return jsonDecode(response.body);

    }
    else
    {
      throw Exception('Failded to load data');
    }

  }

  static Future<dynamic> otpSend(String endpoint,String mobileNo) async {
    final response = await http.post(Uri.parse(baseUrl + endpoint),body: {'mobileNo':mobileNo});
    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      print(data['responseValue'][0]);
      var id = data['responseValue'][0]['verificationID'];
      print(id);
      return id.toString();
      // codeSent(id.toString(),0);
      //return jsonDecode(response.body);

    }
    else
    {
      throw Exception('Failded to load data');
    }

  }

  static signInWithCredential(PhoneAuthCredential credential) async {
    var b = {'id':credential.verificationId,'otp':credential.smsCode};
    print(b);
    var u = Uri.parse(baseUrl + "verifyOtp");
    final response = await http.post(u,body: b);
    print(response.body);
    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      // var id = data['verificationID'];
      // codeSent(id.toString(),0);
      var id = data['responseValue'][0]['id'];
      var mobNo = data['responseValue'][0]['phoneNumber'];
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      var userId = await prefs.setInt('userId',id);
      var mob = await prefs.setString('phoneNumber',mobNo);
      return data;

    }
    else
    {
      throw Exception('Failded to load data');
    }
  }

  static updateUserProfile(UserModel user) async {
    var b = {'name':user.name,'mobileNo':user.phoneNumber,'imageUrl':user.profilePic,'isOnline':user.isOnline ? '1' : '0'};
    print(b);
    var u = Uri.parse(baseUrl + "updateUserInfo");
    final response = await http.post(u,body: b);
    print(response.body);
    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      // var id = data['verificationID'];
      // codeSent(id.toString(),0);
      var id = data['responseValue'][0]['id'];
      var mobNo = data['responseValue'][0]['phoneNumber'];
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      var userId = await prefs.setInt('userId',id);
      var mob = await prefs.setString('phoneNumber',mobNo);
      return data;

    }
    else
    {
      throw Exception('Failded to load data');
    }

  }

  static updateUserState(userId, bool isOnline) async {
    var b = {'id':userId,'isOnline':isOnline};
    print(b);
    var u = Uri.parse(baseUrl + "updateUserState");
    final response = await http.post(u,body: b);
    print(response.body);
    if(response.statusCode == 200)
    {
      // var data = jsonDecode(response.body);
      // var id = data['verificationID'];
      // codeSent(id.toString(),0);
      return jsonDecode(response.body);

    }
    else
    {
      throw Exception('Failded to load data');
    }
  }


  static uploadFile(File file, String path) async {
    print('heyyyyyyyyyyyyyyyyyyyyyyyy');
    var request = await http.MultipartRequest('POST', Uri.parse('https://corncall.com:2087/upload/'));
    request.fields['custompath'] = path.toString();
    // request.fields.addAll({
    //   'custompath': path.toString()
    // });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      var data1 = jsonDecode(data);
      var url = data1['url'];
      return url;


    }
    else {
      throw Exception(response.reasonPhrase);
      print(response.reasonPhrase);
    }
  }

}