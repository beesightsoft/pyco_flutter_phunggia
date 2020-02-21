import 'package:bflutter/bflutter.dart';
import 'package:bflutter_poc/models/remote/person.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc {
  final favoritesBloc = Bloc<Person, List<Person>>();

  List<Person> favoritesList;

  FavoritesBloc() {
    _initLogic();
  }

  void _initLogic() {
    favoritesBloc.logic = (Observable<Person> input) =>
        input.asyncMap((data) {
          favoritesList.add(data);
          return favoritesList;
        });
  }

  void addToFavorites(Person p) {
    favoritesBloc.push(p);
  }

  void dispose() {
    favoritesBloc.dispose();
  }
}