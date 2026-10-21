import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';

class FoodDetailSheet extends StatefulWidget {
  final FoodItem item;
  final Function(int quantity, int totalPrice, String details) onOrderConfirmed;

  const FoodDetailSheet({
    super.key,
    required this.item,
    required this.onOrderConfirmed,
  });

  @override
  State<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends State<FoodDetailSheet> {
  int _spicyLevel = 3; // Default Level 3 (Pedas Banget) as seen in Figma
  bool _addEgg = true; // +Rp 4.000
  bool _addCrackers = false; // +Rp 2.000
  int _quantity = 2; // Default 2 as seen in Figma
  final TextEditingController _noteController =
      TextEditingController(text: 'Jangan pakai seledri ya mas');

  int get _calculatedPrice {
    int base = widget.item.price;
    if (_addEgg) base += 4000;
    if (_addCrackers) base += 2000;
    return base * _quantity;
  }

  String _formatRp(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Header: Item photo + Title + Price
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.item.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.accentSoft,
                      child: const Icon(Icons.fastfood, color: AppColors.primaryPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatRp(widget.item.price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.dividerColor),
            const SizedBox(height: 8),

            // Tingkat Kepedasan
            Row(
              children: [
                const Text(
                  'Tingkat Kepedasan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '(Wajib pilih 1)',
                    style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildRadioOption(1, 'Level 1 (Tidak Pedas)'),
            _buildRadioOption(2, 'Level 2 (Pedas Sedang)'),
            _buildRadioOption(3, 'Level 3 (Pedas Banget)'),

            const SizedBox(height: 14),
            const Divider(color: AppColors.dividerColor),
            const SizedBox(height: 8),

            // Tambahan Topping
            Row(
              children: const [
                Text(
                  'Tambahan Topping',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '(Opsional)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCheckboxOption(
              'Tambah Telur Dadar',
              '+Rp 4.000',
              _addEgg,
              (v) => setState(() => _addEgg = v ?? false),
            ),
            _buildCheckboxOption(
              'Ekstra Kerupuk Kaleng',
              '+Rp 2.000',
              _addCrackers,
              (v) => setState(() => _addCrackers = v ?? false),
            ),

            const SizedBox(height: 14),
            const Divider(color: AppColors.dividerColor),
            const SizedBox(height: 8),

            // Catatan Khusus untuk Dapur
            const Text(
              'Catatan Khusus untuk Dapur',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Contoh: Jangan pakai seledri ya mas',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                filled: true,
                fillColor: const Color(0xFFF6F8FC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryPurple),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom controls: Stepper + Button
            Row(
              children: [
                // Stepper: [-] 2 [+]
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accentPastel),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove, size: 18, color: AppColors.primaryPurple),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add, size: 18, color: AppColors.primaryPurple),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm Order Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onOrderConfirmed(
                        _quantity,
                        _calculatedPrice,
                        'Level $_spicyLevel ${_addEgg ? "+ Telur Dadar" : ""}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Konfirmasi Pesanan ${_formatRp(_calculatedPrice)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(int value, String title) {
    final isSelected = _spicyLevel == value;
    return InkWell(
      onTap: () => setState(() => _spicyLevel = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryPurple : AppColors.accentPastel.withOpacity(0.4),
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.accentPastel,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(
    String title,
    String price,
    bool isChecked,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isChecked ? AppColors.primaryPurple : AppColors.accentPastel.withOpacity(0.4),
                border: Border.all(
                  color: isChecked ? AppColors.primaryPurple : AppColors.accentPastel,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
