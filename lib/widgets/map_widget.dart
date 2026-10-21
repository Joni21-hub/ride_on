import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RideMapWidget extends StatelessWidget {
  final bool showDriver;
  final String driverEta;

  const RideMapWidget({
    super.key,
    this.showDriver = false,
    this.driverEta = 'Pikri (3 mnt)',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4F2),
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _MapPainter(),
          ),
          // Back button
          Positioned(
            top: 48,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
            ),
          ),
          // Destination Banner: Kota Krukuh
          Positioned(
            top: 76,
            right: 48,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF90181A),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Text(
                'Kota Krukuh',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Pickup Marker: Titik Jemput Kamu
          Positioned(
            top: 245,
            left: 54,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF0D4740),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Text(
                'Titik Jemput Kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // If Driver is en route
          if (showDriver)
            Positioned(
              top: 190,
              left: 110,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      driverEta,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Green blocks / Parks
    final blockPaint = Paint()
      ..color = const Color(0xFFD6F5E3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.05, height * 0.08, width * 0.28, height * 0.08),
        const Radius.circular(16),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.62, height * 0.18, width * 0.32, height * 0.12),
        const Radius.circular(16),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.05, height * 0.38, width * 0.28, height * 0.08),
        const Radius.circular(16),
      ),
      blockPaint,
    );

    // City building blocks (Grey/Lavender blocks)
    final bldgPaint = Paint()
      ..color = const Color(0xFFDEE5EE)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.55, height * 0.09, width * 0.38, height * 0.06),
        const Radius.circular(12),
      ),
      bldgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.08, height * 0.17, width * 0.32, height * 0.05),
        const Radius.circular(12),
      ),
      bldgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.08, height * 0.23, width * 0.22, height * 0.04),
        const Radius.circular(12),
      ),
      bldgPaint,
    );

    // River
    final riverPaint = Paint()
      ..color = const Color(0xFFCCE4FF)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(0, height * 0.28);
    riverPath.quadraticBezierTo(width * 0.5, height * 0.32, width, height * 0.31);
    canvas.drawPath(riverPath, riverPaint);

    // Dark green roads grid (from Figma)
    final roadPaint = Paint()
      ..color = const Color(0xFF0F4E46)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    canvas.drawLine(Offset(0, height * 0.15), Offset(width, height * 0.15), roadPaint);
    canvas.drawLine(Offset(0, height * 0.36), Offset(width, height * 0.36), roadPaint);
    canvas.drawLine(Offset(0, height * 0.48), Offset(width, height * 0.48), roadPaint);

    // Vertical roads
    canvas.drawLine(Offset(width * 0.22, 0), Offset(width * 0.22, height), roadPaint);
    canvas.drawLine(Offset(width * 0.45, 0), Offset(width * 0.45, height), roadPaint);
    canvas.drawLine(Offset(width * 0.75, 0), Offset(width * 0.75, height), roadPaint);

    // Road dashed white centerlines
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, Offset(0, height * 0.15), Offset(width, height * 0.15), dashPaint);
    _drawDashedLine(canvas, Offset(width * 0.45, 0), Offset(width * 0.45, height), dashPaint);

    // Ride Route (Purple glow + dashed line)
    final routeGlowPaint = Paint()
      ..color = AppColors.primaryPurple.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = AppColors.primaryPurple
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePath = Path();
    routePath.moveTo(width * 0.27, height * 0.24); // Pickup
    routePath.lineTo(width * 0.27, height * 0.15);
    routePath.lineTo(width * 0.72, height * 0.15);
    routePath.lineTo(width * 0.72, height * 0.11); // Dest

    canvas.drawPath(routePath, routeGlowPaint);
    canvas.drawPath(routePath, routePaint);

    // Pickup point circle
    final pickupCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pickupBorderPaint = Paint()
      ..color = const Color(0xFF0D4740)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width * 0.27, height * 0.24), 9, pickupBorderPaint);
    canvas.drawCircle(Offset(width * 0.27, height * 0.24), 6, pickupCirclePaint);
    canvas.drawCircle(Offset(width * 0.27, height * 0.24), 3, pickupBorderPaint);

    // Destination point circle
    final destPinPaint = Paint()
      ..color = AppColors.primaryPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(width * 0.72, height * 0.11), 8, destPinPaint);
    canvas.drawCircle(Offset(width * 0.72, height * 0.11), 4, pickupCirclePaint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final count = (dx.abs() > dy.abs() ? dx.abs() : dy.abs()) / (dashWidth + dashSpace);
    final xStep = dx / count;
    final yStep = dy / count;

    for (int i = 0; i < count; i++) {
      final start = Offset(p1.dx + xStep * i, p1.dy + yStep * i);
      final end = Offset(p1.dx + xStep * (i + 0.5), p1.dy + yStep * (i + 0.5));
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
