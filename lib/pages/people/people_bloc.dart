import 'dart:convert';

import 'package:bflutter/bflutter.dart';
import 'package:bflutter_poc/models/remote/person.dart';
import 'package:bflutter_poc/provider/store/remote/random_people_api.dart';
import 'package:rxdart/rxdart.dart';

class PeopleBloc {
  final getRandomPeopleInfo = Bloc<String, List<Person>>();

  final randomPeopleApi = RandomPeopleApi();

  PeopleBloc() {
    _initLogic();
  }

  void _initLogic() {
    getRandomPeopleInfo.logic = (Observable<String> input) =>
        input.asyncMap(randomPeopleApi.getRandomPeopleInfo).asyncMap(
            (data) {
              if (data.statusCode == 200) {
                List peopleFromApi = json.decode(data.body)['results'] as List;
                return peopleFromApi.map((i) => Person.fromJson(i)).toList();
              } else {
                throw Exception(data.body);
              }
            }
        );
  }

  void getCarouselInfo() {
    getRandomPeopleInfo.push('');
  }

  void dispose() {
    getRandomPeopleInfo.dispose();
  }
}