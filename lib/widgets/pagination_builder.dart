import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hn_clone/models/pagination.dart';
import 'package:flutter_hn_clone/states/tab_bar_notifier.dart';
import 'package:flutter_hn_clone/widgets/loading.dart';
import 'package:provider/provider.dart';

class PaginationState<T, K> {
  bool isLoading;
  bool hasMore;
  Exception? error;
  final List<Pagination<T>>? pages;
  final List<K>? keys;

  PaginationState({
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.pages,
    this.keys,
  });

  PaginationState<T, K> copyWith({
    bool? isLoading,
    bool? hasMore,
    Exception? error,
    List<Pagination<T>>? pages,
    List<K>? keys,
  }) {
    return PaginationState<T, K>(
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      pages: pages ?? this.pages,
      keys: keys ?? this.keys,
    );
  }

  List<T> get items =>
      pages
          ?.map((page) => page.items)
          .toList()
          .expand((element) => element)
          .toList() ??
      [];
}

class PaginationController<T, K> extends ChangeNotifier {
  final K Function(Pagination<T>? lastPage) getNextPageKey;
  final Future<Pagination<T>> Function(K key) fetchPage;

  PaginationState<T, K> state = PaginationState<T, K>();

  PaginationController({required this.getNextPageKey, required this.fetchPage});

  Future<void> _load() async {
    try {
      final key = getNextPageKey(state.pages?.last);
      final items = await fetchPage(key);
      state = state.copyWith(
        isLoading: false,
        hasMore: getNextPageKey(items) != null,
        pages: [...?state.pages, items],
        keys: [...?state.keys, key],
      );
    } on Exception catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    notifyListeners();

    await _load();
  }

  Future<void> refresh() async {
    if (state.isLoading) {
      return;
    }

    state = PaginationState();
    await _load();
  }
}

class PaginationBuilder<T, K> extends StatefulWidget {
  final PaginationController<T, K> controller;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const PaginationBuilder({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() => _PaginationBuilderState<T, K>();
}

class _PaginationBuilderState<T, K> extends State<PaginationBuilder<T, K>> {
  late TabBarNotifier? _tabBarNotifier;
  bool _showTopFade = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();

    _loadMore();
    widget.scrollController.addListener(_onScroll);
    widget.controller.addListener(_onStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabBarNotifier = context.read<TabBarNotifier>();
  }

  void _onScroll() {
    final shouldTopFade = widget.scrollController.offset > 0;
    if (_showTopFade != shouldTopFade) {
      setState(() {
        _showTopFade = shouldTopFade;
      });
    }

    final direction = widget.scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _tabBarNotifier?.hide();
    }
    if (direction == ScrollDirection.forward) {
      _tabBarNotifier?.show();
    }

    if (widget.controller.state.isLoading) {
      return;
    }

    if (widget.scrollController.position.pixels >
        widget.scrollController.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  void _loadMore() {
    widget.controller.loadMore();
  }

  void _onStateChanged() {
    if (_isInitialLoading) {
      setState(() {
        _isInitialLoading = false;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    await widget.controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final pageState = widget.controller.state;

    if (_isInitialLoading) {
      return LoadingWidget(translateY: -50);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Stack(
        children: [
          ListView.separated(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: pageState.hasMore
                  ? 20.0
                  : MediaQuery.of(context).padding.bottom,
            ),
            controller: widget.scrollController,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemCount: pageState.hasMore
                ? pageState.items.length + 1
                : pageState.items.length,
            itemBuilder: (context, index) {
              if (index == pageState.items.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Visibility(
                      visible: pageState.isLoading,
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              }
              return widget.itemBuilder(context, pageState.items[index], index);
            },
          ),
          _buildTopFade(context),
        ],
      ),
    );
  }

  Widget _buildTopFade(BuildContext context) {
    final themeData = Theme.of(context);

    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: _showTopFade ? 1.0 : 0.0,
      child: IgnorePointer(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeData.scaffoldBackgroundColor,
                themeData.scaffoldBackgroundColor.withAlpha(0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
