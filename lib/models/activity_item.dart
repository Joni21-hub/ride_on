enum ActivityType { food, ride, send }

class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final String dateTime;
  final int totalAmount;
  final String status;
  final String driverName;
  final String vehicleInfo;
  final String pickupAddress;
  final String dropoffAddress;
  final int foodPrice;
  final int deliveryFee;
  final int otherFee;
  int foodRating;
  int driverRating;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.totalAmount,
    this.status = 'Makanan sudah diantar',
    this.driverName = 'Gufran Fadlurahman',
    this.vehicleInfo = 'Honda supra | BL67SI',
    this.pickupAddress = 'Nasi Goreng Mas Fuad, Kreung Geukueh',
    this.dropoffAddress = 'Kos Dokter Gufran, Kreung Geukueh',
    this.foodPrice = 25000,
    this.deliveryFee = 3000,
    this.otherFee = 1500,
    this.foodRating = 5,
    this.driverRating = 5,
  });

  static List<ActivityItem> initialList() {
    return [
      ActivityItem(
        id: 'TB-991823',
        type: ActivityType.send,
        title: 'Titip Belanja: Pasar Tradisional & Apotek',
        subtitle: 'Daging, cabai, bawang, santan & obat • Talangan Rp 142.000',
        dateTime: '5, Okt 2026, 12:48',
        totalAmount: 157000,
        status: 'Belanjaan Selesai & Diterima',
        driverName: 'Joni Utama',
        vehicleInfo: 'Honda Vario 160 Hitam | BK 4892 ABC',
        pickupAddress: 'Pasar Tradisional Sukaramai & Apotek Kimia Farma',
        dropoffAddress: 'Jl. Medan - Banda Aceh No. 45, Batuphat Timur',
        foodPrice: 142000, // Total talangan riil belanja + parkir
        deliveryFee: 15000, // Total ongkir rute + multi-toko + item
        otherFee: 0,
        foodRating: 5,
        driverRating: 5,
      ),
      ActivityItem(
        id: 'F-120707',
        type: ActivityType.food,
        title: 'Nasi Goreng Mas Fuad',
        subtitle: '1x Nasi goreng + telur mata sapi, 1x Es teh hijau',
        dateTime: '28, Sep 2026, 07:21',
        totalAmount: 29500,
        status: 'Makanan sudah diantar',
        driverName: 'Gufran Fadlurahman',
        vehicleInfo: 'Honda supra | BL67SI',
        pickupAddress: 'Nasi Goreng Mas Fuad, Kreung Geukueh',
        dropoffAddress: 'Kos Dokter Gufran, Kreung Geukueh',
        foodPrice: 25000,
        deliveryFee: 3000,
        otherFee: 1500,
        foodRating: 5,
        driverRating: 5,
      ),
      ActivityItem(
        id: 'R-883912',
        type: ActivityType.ride,
        title: 'Perjalanan Dari Kreung Geukueh ke Kampus Unimal Reulet',
        subtitle: 'Flex Motor (Jarak tempuh 4.2 Km)',
        dateTime: '15, Jan 2026, 20:21',
        totalAmount: 19500,
        status: 'Perjalanan Selesai',
        driverName: 'Pikri Haykal',
        vehicleInfo: 'Honda Vario 160 Hitam | BG 4563 R',
        pickupAddress: 'Jl. Brawl No. 77 (Depan Mr.DIY)',
        dropoffAddress: 'Kampus Unimal Reulet, Gedung Rektorat',
        foodPrice: 16000,
        deliveryFee: 2500,
        otherFee: 1000,
        foodRating: 5,
        driverRating: 5,
      ),
    ];
  }
}
