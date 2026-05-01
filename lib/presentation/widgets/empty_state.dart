import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  final bool isSearch;
  final String searchQuery;

  const EmptyState({
    super.key,
    this.isSearch = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                isSearch
                    ? Icons.search_off_rounded
                    : Icons.note_add_outlined,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              isSearch ? 'No results found' : 'No notes yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              isSearch
                  ? 'No notes match "$searchQuery".\nTry a different search term.'
                  : 'Tap the + button to create your first note.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
