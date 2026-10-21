import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_sheet.dart';
import 'flex_ride_screen.dart';
import 'flex_food_screen.dart';
import 'flex_send_screen.dart';
import 'titip_belanja_screen.dart';

class HomeTab extends StatefulWidget {
  final List<FoodItem> foodItems;
  final Function(FoodItem) onToggleFavorite;
  final VoidCallback onOpenProfile;

  const HomeTab({
    super.key,
    required this.foodItems,
    required this.onToggleFavorite,
    required this.onOpenProfile,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedService = 0; // 0 = FlexRide, 1 = FlexFood, 2 = FlexSend

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Purple background with GPS Pinpoint + Search + Profile/Login button + E-Wallet Card
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8667FD), Color(0xFFC7BCFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      // GPS Pinpoint Location Bar & Notification Bell (Halaman 2: GPS Pinpoint)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.location_on, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Batuphat Timur, Lhokseumawe',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.textDark, size: 14),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Notification Bell with Badge
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.92),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_outlined, color: AppColors.textDark, size: 18),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Search Bar & Profile Pill
                      Row(
                        children: [
                          // Search Bar
                          Expanded(
                            child: Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.search, color: AppColors.textDark, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Cari layanan, pasar, resto...',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Login / Profile Pill Button
                          GestureDetector(
                            onTap: widget.onOpenProfile,
                            child: Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: AssetImage('assets/images/avatar_peter.png'),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Peter',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Kartu E-Wallet (Halaman 2: Saldo, Top Up, Riwayat)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F0FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.account_balance_wallet, color: AppColors.primaryPurple, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Saldo FlexPay E-Wallet',
                                      style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Rp 145.000',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Simulasi Top Up Berhasil: Saldo bertambah Rp 50.000'),
                                        backgroundColor: AppColors.successGreen,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.add_circle_outline, color: Colors.white, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'Top Up',
                                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Prime Day Sale Banner
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/banner_prime.png',
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7B52FC), Color(0xFF5D31F5)],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Prime Day Sale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'UP TO 60% OFF',
                          style: TextStyle(
                            color: AppColors.goldYellow,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3 Layanan Utama (Grid Menu Halaman 2: Titip Belanja, Pesan Makanan, Antar Jemput)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -34,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildServiceItem(
                        index: 0,
                        title: 'Titip Belanja',
                        icon: Icons.shopping_basket_rounded,
                        onTap: () {
                          setState(() => _selectedService = 0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TitipBelanjaScreen()),
                          );
                        },
                      ),
                      _buildServiceItem(
                        index: 1,
                        title: 'Pesan Makanan',
                        icon: Icons.restaurant_rounded,
                        onTap: () {
                          setState(() => _selectedService = 1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FlexFoodScreen(
                                items: widget.foodItems,
                                onToggleFavorite: widget.onToggleFavorite,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceItem(
                        index: 2,
                        title: 'Antar Jemput',
                        icon: Icons.two_wheeler_rounded,
                        onTap: () {
                          setState(() => _selectedService = 2);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FlexRideScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 52),

            // Quick Access Pill for FlexSend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FlexSendScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accentPastel),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.inventory_2_outlined, color: AppColors.primaryPurple, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kirim Dokumen & Paket Barang Instant (FlexSend) ->',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 1: FlexFood - Pilihan Terlaris
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.restaurant_menu, size: 14, color: AppColors.textDark),
                          SizedBox(width: 4),
                          Text(
                            'FlexFood',
                            style: TextStyle(
                              fontSize: 14,
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
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlexFoodScreen(
                            items: widget.foodItems,
                            onToggleFavorite: widget.onToggleFavorite,
                          ),
                        ),
                      );
                    },
                    child: const Text('Lihat Semua', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal Food Carousel
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: widget.foodItems.length,
                itemBuilder: (context, index) {
                  final item = widget.foodItems[index];
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
            ),

            const SizedBox(height: 24),

            // Section 2: Cek promo sekarang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.discount, size: 14, color: AppColors.textDark),
                  SizedBox(width: 6),
                  Text(
                    'Cek promo sekarang',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Promo Banner Carousel
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/banner_gratisongkir.png',
                      width: 290,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 290,
                        height: 130,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Tiap Hari Belanja Hemat\nGRATIS ONGKIR SETIAP SAAT',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 290,
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B6BFD), Color(0xFF6B48FC)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Cashback FlexPay 50%',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gunakan kode: RIDEONHEMAT',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Rekomendasi wisata
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.explore, size: 14, color: AppColors.textDark),
                  SizedBox(width: 6),
                  Text(
                    'Rekomendasi wisata',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            _buildWisataCard(
              title: 'Gunung Rinjani',
              badge: 'Bestseller',
              imageAsset: 'assets/images/wisata_rinjani.png',
              description:
                  'Jangan salah, kami sedia Ojek Gunung! Hemat waktu dan tenaga dari basecamp ke POS 2. Pesan sekarang dan nikmati perjalanan aman bersama driver profesional kami.',
            ),
            _buildWisataCard(
              title: 'Ranu Kumbolo',
              badge: 'Bestseller',
              imageAsset: 'assets/images/wisata_ranukumbolo.png',
              description:
                  'Pesona magis Ranu Kumbolo menantimu! Bebaskan penatmu dan nikmati syahdunya berkemah di surga Semeru. Siapkan ranselmu dan rencanakan pendakianmu sekarang',
            ),
            _buildWisataCard(
              title: 'Banda Neira',
              badge: 'Bestseller',
              imageAsset: 'assets/images/wisata_bandaneira.png',
              description:
                  'Banda Neira, kepingan surga di Maluku! Nikmati pesona bawah laut eksotis dan kekayaan sejarah yang mendunia. Wujudkan liburan impianmu sekarang',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required int index,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedService == index;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFC6BCFF) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primaryPurple : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWisataCard({
    required String title,
    required String badge,
    required String imageAsset,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imageAsset,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.deepPurple[200],
                    child: const Center(child: Icon(Icons.terrain, color: Colors.white, size: 40)),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBB676),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
