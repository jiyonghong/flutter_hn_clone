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
