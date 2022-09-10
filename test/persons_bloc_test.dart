import 'package:block_practice/bloc/bloc_actions.dart';
import 'package:block_practice/bloc/person.dart';
import 'package:block_practice/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(
    name: 'John',
    age: 20,
  ),
  Person(
    name: 'Jane',
    age: 21,
  ),
];

const mockedPersons2 = [
  Person(
    name: 'John',
    age: 20,
  ),
  Person(
    name: 'Jane',
    age: 21,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) => Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) => Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    // write our tests
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(
        bloc.state,
        null,
        // const FetchResult(
        //   persons: [],
        //   isRetrieveFromCache: false,
        // ),
      ),
    );

    // fetch mock data [persons1] and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons1 from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'url',
            loader: mockGetPersons1,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'url',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons1,
          isRetrieveFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isRetrieveFromCache: true,
        ),
      ],
    );

    // fetch mock data [persons2] and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons1 from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'url_2',
            loader: mockGetPersons2,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons2,
          isRetrieveFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isRetrieveFromCache: true,
        ),
      ],
    );
  });
}
