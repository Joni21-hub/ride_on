class FoodItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageAsset;
  bool isFavorite;
  final String restaurantName;
  final double rating;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.isFavorite = false,
    this.restaurantName = 'Banku City',
    this.rating = 4.8,
  });

  static List<FoodItem> initialList() {
    return [
      FoodItem(
        id: '1',
        name: 'Bakso Urat',
        description: 'Bakso unta bakso dino',
        price: 25000,
        imageAsset: 'assets/images/bakso_urat.png',
        isFavorite: false,
      ),
      FoodItem(
        id: '2',
        name: 'Kebab Turki',
        description: 'Menggunakan daging unta turki',
        price: 37000,
        imageAsset: 'assets/images/kebab_turki.png',
        isFavorite: true,
      ),
      FoodItem(
        id: '3',
        name: 'Nasi Ayam Bakar',
        description: 'Nasi ayam bakar ayam',
        price: 19000,
        imageAsset: 'assets/images/ayam_bakar.png',
        isFavorite: true,
      ),
      FoodItem(
        id: '4',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng + telur mata sapi',
        price: 10000,
        imageAsset: 'assets/images/nasi_goreng.png',
        isFavorite: false,
      ),
      FoodItem(
        id: '5',
        name: 'Rendang Siujang',
        description: 'Rendang khas padang buatan uajang',
        price: 48000,
        imageAsset: 'assets/images/rendang.png',
        isFavorite: true,
      ),
      FoodItem(
        id: '6',
        name: 'Burger Daging',
        description: 'Burger daging rasa daging premium',
        price: 19000,
        imageAsset: 'assets/images/burger.png',
        isFavorite: false,
      ),
      FoodItem(
        id: '7',
        name: 'Pempek Asli',
        description: 'Pempek asli khas Palembang cuko sedap',
        price: 60000,
        imageAsset: 'assets/images/pempek.png',
        isFavorite: false,
      ),
      FoodItem(
        id: '8',
        name: 'Mie Ayam Mang Joni',
        description: 'Mie ayam jantan kuah kental gurih',
        price: 14000,
        imageAsset: 'assets/images/mie_ayam.png',
        isFavorite: false,
      ),
    ];
  }
}
