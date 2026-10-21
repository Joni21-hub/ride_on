import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_sheet.dart';

class FlexFoodScreen extends StatefulWidget {
  final List<FoodItem> items;
  final Function(FoodItem) onToggleFavorite;

  const FlexFoodScreen({
    super.key,
    required this.items,
    required this.onToggleFavorite,
  });

  @override
  State<FlexFoodScreen> createState() => _FlexFoodScreenState();
}

class _FlexFoodScreenState extends State<FlexFoodScreen> {
  String _searchQuery = '';

  void _openDetailSheet(FoodItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodDetailSheet(
        item: item,
        onOrderConfirmed: (qty, total, details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pesanan $qty x ${item.name} berhasil dikonfirmasi!'),
              backgroundColor: AppColors.primaryPurple,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((f) {
      if (_searchQuery.isEmpty) return true;
      return f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8667FD), Color(0xFFC7BCFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'FlexFood',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.textDark),
                  hintText: 'Cari makanan atau resto terdekat...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Heading: FlexFood Pilihan Terlaris
            Row(
              children: const [
                Icon(Icons.restaurant_menu, size: 16, color: AppColors.textDark),
                SizedBox(width: 6),
                Text(
                  'FlexFood',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const Text(
              'Pilihan Terlaris',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            // 3-Column Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                childAspectRatio: 0.58,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return FoodCard(
                  item: item,
                  onTap: () => _openDetailSheet(item),
                  onFavoriteToggle: () {
                    setState(() {
                      widget.onToggleFavorite(item);
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
