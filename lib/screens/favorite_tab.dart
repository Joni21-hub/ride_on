import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_sheet.dart';

class FavoriteTab extends StatefulWidget {
  final List<FoodItem> items;
  final Function(FoodItem) onToggleFavorite;

  const FavoriteTab({
    super.key,
    required this.items,
    required this.onToggleFavorite,
  });

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
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
              content: Text('Pesanan $qty item (${item.name}) berhasil dikonfirmasi!'),
              backgroundColor: AppColors.primaryPurple,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = widget.items.where((f) => f.isFavorite).toList();

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
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 38,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Favorit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Mascot + Speech bubble (from Figma favorite.png)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/mascot.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.accentSoft,
                      child: Icon(Icons.favorite, color: AppColors.primaryPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6BCFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Cari Kembali favorit Mu!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (favorites.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: const [
                    Icon(Icons.favorite_border, size: 54, color: AppColors.textMuted),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada menu favorit yang disimpan',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              // Grid of 3 columns
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.58,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
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
