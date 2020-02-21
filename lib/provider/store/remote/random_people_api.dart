import 'package:bflutter_poc/provider/store/remote/api.dart';
import 'package:http/http.dart' as http;

class RandomPeopleApi extends Api {
  Future<http.Response> getRandomPeopleInfo(String username) async {
    String url = 'https://randomuser.me/api/0.4/?results=3';
    return http.get(url);
  }
}