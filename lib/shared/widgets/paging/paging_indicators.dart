import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:dt_digital_studio/shared/widgets/app_loading.dart';

/// Default widget builders for [infinite_scroll_pagination].
///
/// Use with [PagedListView], [PagedGridView], etc.
///
/// Example:
/// ```dart
/// PagedListView<int, MyItem>(
///   pagingController: _pagingController,
///   builderDelegate: PagedChildBuilderDelegate<MyItem>(
///     itemBuilder: (context, item, index) => MyTile(item),
///     firstPageProgressIndicatorBuilder: PagingIndicators.firstPageProgress,
///     newPageProgressIndicatorBuilder: PagingIndicators.newPageProgress,
///     noItemsFoundIndicatorBuilder: PagingIndicators.noItemsFound,
///     firstPageErrorIndicatorBuilder: (ctx) =>
///         PagingIndicators.firstPageError(ctx, controller),
///     newPageErrorIndicatorBuilder: (ctx) =>
///         PagingIndicators.newPageError(ctx, controller),
///     noMoreItemsIndicatorBuilder: PagingIndicators.noMoreItems,
///   ),
/// )
/// ```
abstract final class PagingIndicators {
  /// Shown while the first page is loading.
  static Widget firstPageProgress(BuildContext context) =>
      const AppLoading(fullScreen: false);

  /// Shown while a subsequent page is loading.
  static Widget newPageProgress(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16),
        child: AppLoading(fullScreen: false),
      );

  /// Shown when the list is empty after the first page loads.
  static Widget noItemsFound(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      );

  /// Shown when the first page errors. Provides a Retry button.
  static Widget firstPageError<PageKeyType, ItemType>(
    BuildContext context,
    PagingController<PageKeyType, ItemType> controller,
  ) =>
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: controller.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  /// Shown when a subsequent page errors. Provides an inline retry.
  static Widget newPageError<PageKeyType, ItemType>(
    BuildContext context,
    PagingController<PageKeyType, ItemType> controller,
  ) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load more',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: controller.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  /// Shown below the last item when all pages are loaded.
  static Widget noMoreItems(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '— End of list —',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
}
