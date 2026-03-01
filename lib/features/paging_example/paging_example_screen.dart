import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:dt_digital_studio/shared/widgets/app_loading.dart';
import 'package:dt_digital_studio/shared/widgets/paging/paging_indicators.dart';

// ---- Fake data model ---------------------------------------------------------

class _Post {
  const _Post({required this.id, required this.title, required this.body});
  final int id;
  final String title;
  final String body;
}

// ---- Fake API ----------------------------------------------------------------

class _FakeApi {
  static const _totalItems = 35;
  static const _pageSize = 10;

  static Future<List<_Post>> getPosts(int pageKey) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final startIndex = (pageKey - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _totalItems);
    return List.generate(
      endIndex - startIndex,
      (i) => _Post(
        id: startIndex + i + 1,
        title: 'Post #${startIndex + i + 1}',
        body: 'This is the body content for post ${startIndex + i + 1}. '
            'It gives you a feel of how real data would look here.',
      ),
    );
  }
}

// ---- Example screen ----------------------------------------------------------

/// Demonstrates [infinite_scroll_pagination] v5 + [PagingIndicators] + shimmer.
class PagingExampleScreen extends StatefulWidget {
  const PagingExampleScreen({super.key});

  @override
  State<PagingExampleScreen> createState() => _PagingExampleScreenState();
}

class _PagingExampleScreenState extends State<PagingExampleScreen> {
  static const _kTotalItems = 35;

  late final _pagingController = PagingController<int, _Post>(
    getNextPageKey: (state) {
      // If the last page we fetched is empty — no more pages
      if (state.lastPageIsEmpty) return null;
      final nextKey = (state.keys?.last ?? 0) + 1;
      // End paging when we've loaded all items
      final loadedCount = state.items?.length ?? 0;
      return loadedCount >= _kTotalItems ? null : nextKey;
    },
    fetchPage: _FakeApi.getPosts,
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paging Example')),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(_pagingController.refresh),
        child: PagingListener<int, _Post>(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) => PagedListView<int, _Post>(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(16),
            builderDelegate: PagedChildBuilderDelegate<_Post>(
              animateTransitions: true,
              itemBuilder: (context, post, index) => _PostCard(post: post),
              firstPageProgressIndicatorBuilder: (_) => _ShimmerList(),
              newPageProgressIndicatorBuilder:
                  PagingIndicators.newPageProgress,
              noItemsFoundIndicatorBuilder: PagingIndicators.noItemsFound,
              firstPageErrorIndicatorBuilder: (ctx) =>
                  PagingIndicators.firstPageError(ctx, _pagingController),
              newPageErrorIndicatorBuilder: (ctx) =>
                  PagingIndicators.newPageError(ctx, _pagingController),
              noMoreItemsIndicatorBuilder: PagingIndicators.noMoreItems,
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Post card ---------------------------------------------------------------

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final _Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    '${post.id}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Shimmer skeleton --------------------------------------------------------

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppShimmer(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
