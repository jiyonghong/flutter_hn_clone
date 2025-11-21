import 'package:drift/drift.dart';
import 'package:flutter_hn_clone/db/database.dart';
import 'package:flutter_hn_clone/db/tables/bookmarks.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Stream<List<Bookmark>> watchBookmarks() {
    return select(bookmarks).watch();
  }

  Stream<Set<int>> watchBookmarkedItemIds() {
    return watchBookmarks().map(
      (bookmarks) => bookmarks.map((bookmark) => bookmark.itemId).toSet(),
    );
  }

  Future<int> createBookmark(BookmarksCompanion bookmark) {
    return into(bookmarks).insert(bookmark);
  }

  Future<int> deleteBookmark(int itemId) {
    return (delete(bookmarks)..where((t) => t.itemId.equals(itemId))).go();
  }

  Future<void> toggleBookmark(BookmarksCompanion bookmark) async {
    final query = select(bookmarks)
      ..where((t) => t.itemId.equals(bookmark.itemId.value));
    final item = await query.getSingleOrNull();

    if (item != null) {
      await deleteBookmark(item.itemId);
    } else {
      await createBookmark(bookmark);
    }
  }
}
