class Pagination<T> {
  final int page;
  final int limit;
  final bool hasNext;
  final List<T> items;

  Pagination({
    required this.page,
    required this.limit,
    required this.hasNext,
    required this.items,
  });
}

Pagination<T> paginate<T>(List<T> items, int page, [int limit = 20]) {
  final startIndex = (page - 1) * limit;
  final endIndex = startIndex + limit;

  if (items.length < endIndex) {
    return Pagination(
      page: page,
      limit: limit,
      hasNext: false,
      items: items.sublist(startIndex),
    );
  }

  return Pagination(
    page: page,
    limit: limit,
    hasNext: true,
    items: items.sublist(startIndex, endIndex),
  );
}
