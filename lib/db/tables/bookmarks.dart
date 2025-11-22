import 'package:drift/drift.dart';

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  TextColumn get title => text().withLength(max: 500)();
  TextColumn get by => text().withLength(max: 100)();
  IntColumn get time => integer()();
  TextColumn get url => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get score => integer()();
}
