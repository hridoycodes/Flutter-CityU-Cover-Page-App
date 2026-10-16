import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cityu_cover_page/core/themes/app_colors.dart';

class BottomSheetWidget extends StatelessWidget {
  final String label;
  final String itemName;
  final List<String> items;
  final Function(String type) onSelectItem;

  const BottomSheetWidget({
    super.key,
    required this.label,
    required this.itemName,
    required this.items,
    required this.onSelectItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(HugeIcons.strokeRoundedCancel01),
              )
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = items[index];
                final bool isSelected = itemName == item;
                return Card(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.surface,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? const BorderSide(width: 1, color: AppColors.primary)
                        : const BorderSide(width: 1, color: AppColors.border)
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      onSelectItem(item);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(item),
                      trailing: isSelected
                          ? const Icon(
                              HugeIcons.strokeRoundedCheckmarkSquare02,
                              color: AppColors.primary,
                            )
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}