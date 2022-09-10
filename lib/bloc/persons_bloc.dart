import 'package:block_practice/bloc/bloc_actions.dart';
import 'package:block_practice/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T> {
  bool isEqualIgnoringOrdering(Iterable<T> other) {
    final thisSet = Set<T>.from(this);
    final otherSet = Set<T>.from(other);
    // return thisSet.length == otherSet.length && thisSet.difference(otherSet).isEmpty;
    return thisSet.length == otherSet.length && thisSet.intersection(otherSet).length == length;
  }
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrieveFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrieveFromCache,
  });

  @override
  String toString() => 'FetchResult { persons: $persons, isRetrieveFromCache: $isRetrieveFromCache }';

  @override
  bool operator ==(covariant FetchResult other) => persons.isEqualIgnoringOrdering(other.persons) && isRetrieveFromCache == other.isRetrieveFromCache;

  @override
  int get hashCode => Object.hash(
        persons,
        isRetrieveFromCache,
      );
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrieveFromCache: true,
          );
          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrieveFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
