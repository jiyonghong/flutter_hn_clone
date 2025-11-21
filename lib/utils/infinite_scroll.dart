import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hn_clone/models/pagination.dart';
import 'package:flutter_hn_clone/utils/tab_bar_visibility_notifier.dart';
import 'package:flutter_hn_clone/widgets/loading.dart';

class PagingState<T, K> {
  bool isLoading;
  bool hasMore;
  Exception? error;
  final List<Pagination<T>>? pages;
  final List<K>? keys;

  PagingState({
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.pages,
    this.keys,
  });

  PagingState<T, K> copyWith({
    bool? isLoading,
    bool? hasMore,
    Exception? error,
    List<Pagination<T>>? pages,
    List<K>? keys,
  }) {
    return PagingState<T, K>(
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

class PagingController<T, K> extends ChangeNotifier {
  final K Function(Pagination<T>? lastPage) getNextPageKey;
  final Future<Pagination<T>> Function(K key) fetchPage;

  PagingState<T, K> state = PagingState<T, K>();

  PagingController({required this.getNextPageKey, required this.fetchPage});

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

    state = PagingState();
    await _load();
  }
}

class InfiniteScrollBuilder<T, K> extends StatefulWidget {
  final PagingController<T, K> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const InfiniteScrollBuilder({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() => _InfiniteScrollBuilderState<T, K>();
}

class _InfiniteScrollBuilderState<T, K>
    extends State<InfiniteScrollBuilder<T, K>> {
  final ScrollController _scrollController = ScrollController();
  late TabBarNotifier? _tabBarNotifier;
  bool _showTopFade = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();

    _loadMore();
    _scrollController.addListener(_onScroll);
    widget.controller.addListener(_onStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabBarNotifier = TabBarProvider.read(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldTopFade = _scrollController.offset > 0;
    if (_showTopFade != shouldTopFade) {
      setState(() {
        _showTopFade = shouldTopFade;
      });
    }

    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _tabBarNotifier?.hide();
    }
    if (direction == ScrollDirection.forward) {
      _tabBarNotifier?.show();
    }

    if (widget.controller.state.isLoading) {
      return;
    }

    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 100) {
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
            controller: _scrollController,
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
