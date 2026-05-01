import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ColorPickerRow extends StatelessWidget {
  final int selectedIndex;
  final bool isDark;
  final void Function(int) onColorSelected;

  const ColorPickerRow({
    super.key,
    required this.selectedIndex,
    required this.isDark,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isDark
        ? AppColors.cardColorsDark
        : AppColors.cardColorsLight;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onColorSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                      size: 18,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
