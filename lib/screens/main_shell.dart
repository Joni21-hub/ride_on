import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';
import 'home_tab.dart';
import 'favorite_tab.dart';
import 'activity_tab.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'merchant_view.dart';
import 'driver_view.dart';

enum AppRole { customer, merchant, driver }

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTab = 0;
  AppRole _currentRole = AppRole.customer;
  late List<FoodItem> _foodItems;

  @override
  void initState() {
    super.initState();
    _foodItems = FoodItem.initialList();
  }

  void _toggleFavorite(FoodItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  void _showRolePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ganti Mode Aplikasi (Figma Role Switcher)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih role aplikasi sesuai halaman desain Figma yang ingin diuji:',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            _buildRoleOption(
              role: AppRole.customer,
              title: 'Aplikasi Customer (Utama)',
              subtitle: 'Beranda, FlexRide, FlexFood, Chat, Aktivitas, Profil',
              icon: Icons.person,
            ),
            const SizedBox(height: 8),
            _buildRoleOption(
              role: AppRole.merchant,
              title: 'Aplikasi Toko (Mitra Merchant)',
              subtitle: 'Buka/Tutup gerai, kelola pesanan masuk dapur, katalog menu',
              icon: Icons.storefront,
            ),
            const SizedBox(height: 8),
            _buildRoleOption(
              role: AppRole.driver,
              title: 'Aplikasi Mitra Driver',
              subtitle: 'Radar pesanan, status Online Siaga, navigasi jemput penumpang',
              icon: Icons.two_wheeler,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required AppRole role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _currentRole == role;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() => _currentRole = role);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If Merchant mode selected
    if (_currentRole == AppRole.merchant) {
      return MerchantView(
        onBackToCustomer: () => setState(() => _currentRole = AppRole.customer),
      );
    }

    // If Driver mode selected
    if (_currentRole == AppRole.driver) {
      return DriverView(
        onBackToCustomer: () => setState(() => _currentRole = AppRole.customer),
      );
    }

    // Customer App with 4 Tabs
    final tabs = [
      HomeTab(
        foodItems: _foodItems,
        onToggleFavorite: _toggleFavorite,
        onOpenProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
      FavoriteTab(
        items: _foodItems,
        onToggleFavorite: _toggleFavorite,
      ),
      const ActivityTab(),
      const ChatTab(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          tabs[_currentTab],
          // Floating Role Switcher Pill in Customer Mode
          Positioned(
            top: 48,
            right: 16,
            child: GestureDetector(
              onTap: _showRolePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.swap_horiz, color: AppColors.goldYellow, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Switch Role',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'Beranda', Icons.home_rounded),
            _buildNavItem(1, 'Favorite', Icons.favorite_rounded),
            _buildNavItem(2, 'Aktivitas', Icons.receipt_long_rounded),
            _buildNavItem(3, 'chat', Icons.chat_bubble_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primaryDark : Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
