import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onCtaPressed;

  const HeroSection({super.key, required this.onCtaPressed});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _lensController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _lensController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _radarController.dispose();
    _lensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      height: screenHeight.clamp(600, 1080),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppTheme.bgGradient,
      ),
      child: Stack(
        children: [
          // Background Tech Grid
          const Positioned.fill(
            child: TechGridBackground(),
          ),
          
          // Content Layout
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20.0 : 80.0,
                vertical: 20.0,
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Column: Text & CTA
                  Expanded(
                    flex: isMobile ? 1 : 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        // Live Security Status Tag
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, val, child) {
                            return Opacity(
                              opacity: val,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - val)),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.secondary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.secondary,
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'IKE CONNECT ACTIVE ONLINE MONITORING',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: isMobile ? 10 : 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Hero Title
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, val, child) {
                            return Opacity(
                              opacity: val,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - val)),
                                child: child,
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: isMobile ? TextAlign.center : TextAlign.left,
                            text: TextSpan(
                              style: AppTheme.headlineStyle(
                                size: isMobile ? 38 : 56,
                                isBold: true,
                              ),
                              children: const [
                                TextSpan(text: 'Securing What\nMatters, '),
                                TextSpan(
                                  text: 'Connecting\n',
                                  style: TextStyle(color: AppTheme.primary),
                                ),
                                TextSpan(
                                  text: "What's Next.",
                                  style: TextStyle(color: AppTheme.secondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Subtitle
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1200),
                          builder: (context, val, child) {
                            return Opacity(
                              opacity: val,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - val)),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            'Enterprise-grade security cameras, professional AI analytics, smart access control, and 24/7 technical support. Expertly installed, flawlessly integrated.',
                            textAlign: isMobile ? TextAlign.center : TextAlign.left,
                            style: AppTheme.bodyStyle(
                              size: isMobile ? 14 : 18,
                              isSecondary: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // CTA Buttons
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1400),
                          builder: (context, val, child) {
                            return Opacity(
                              opacity: val,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - val)),
                                child: child,
                              ),
                            );
                          },
                          child: _buildCtaRow(isMobile),
                        ),
                      ],
                    ),
                  ),

                  if (isMobile) const SizedBox(height: 40),

                  // Right Column: Camera Radar Animation
                  Expanded(
                    flex: isMobile ? 1 : 5,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_radarController, _lensController]),
                        builder: (context, child) {
                          return Container(
                            width: isMobile ? 260 : 400,
                            height: isMobile ? 260 : 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.05),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: RadarLensPainter(
                                radarAngle: _radarController.value * 2 * math.pi,
                                pulseScale: 0.95 + (_lensController.value * 0.08),
                                laserOffset: _lensController.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaRow(bool isMobile) {
    return Wrap(
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: [
        // Primary Button (Glowing Security CTA)
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onCtaPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.techGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Get Free Security Quote',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Secondary Button (Watch Demo / Interactive Visualizer)
        OutlinedButton(
          onPressed: widget.onCtaPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: const BorderSide(color: AppTheme.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Explore Systems',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Background Tech Grid Animation
class TechGridBackground extends StatelessWidget {
  const TechGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.04)
      ..strokeWidth = 1.0;

    const double step = 40.0;
    
    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    
    // Draw horizontal grid lines
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Draw tech highlights (circles/nodes in grids)
    final Paint nodePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final math.Random random = math.Random(42);
    for (int i = 0; i < 15; i++) {
      final double rx = random.nextDouble() * size.width;
      final double ry = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(rx, ry), 2.0, nodePaint);
      if (i % 3 == 0) {
        canvas.drawCircle(
          Offset(rx, ry), 
          8.0, 
          Paint()
            ..color = AppTheme.primary.withOpacity(0.02)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Radar Lens Painter draws the spinning radar scanning line & target markers + glowing camera lens
class RadarLensPainter extends CustomPainter {
  final double radarAngle;
  final double pulseScale;
  final double laserOffset;

  RadarLensPainter({
    required this.radarAngle,
    required this.pulseScale,
    required this.laserOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // 1. Draw Outer Concentric Calibration Rings
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Cyan calibration ring
    ringPaint.color = AppTheme.primary.withOpacity(0.15);
    canvas.drawCircle(center, radius, ringPaint);

    // Mid ring
    ringPaint.color = AppTheme.primary.withOpacity(0.1);
    canvas.drawCircle(center, radius * 0.75, ringPaint);

    // Inner ring
    ringPaint.color = AppTheme.primary.withOpacity(0.08);
    canvas.drawCircle(center, radius * 0.5, ringPaint);

    // 2. Draw Radar Sweep (Spinning)
    final double sweepAngle = 35 * math.pi / 180; // 35 degrees sweep arc
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    
    // Draw trailing sweep gradient
    final sweepGradient = RadialGradient(
      center: Alignment.center,
      colors: [
        AppTheme.primary.withOpacity(0.2),
        AppTheme.primary.withOpacity(0.0),
      ],
    );
    
    // Shader to create smooth tail fade
    final Paint gradientSweepPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.fill;
      
    // Draw sweep segment
    canvas.drawArc(
      rect, 
      radarAngle - sweepAngle, 
      sweepAngle, 
      true, 
      gradientSweepPaint
    );

    // Draw the bright leading edge of the radar sweep
    final Paint leadPaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.5)
      ..strokeWidth = 2.0;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * math.cos(radarAngle),
        center.dy + radius * math.sin(radarAngle),
      ),
      leadPaint,
    );

    // 3. Draw Camera Lens Glass and Aperture
    final double lensRadius = radius * 0.45 * pulseScale;
    
    // Lens body/bezel
    final Paint bezelPaint = Paint()
      ..color = AppTheme.surface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, lensRadius + 6, bezelPaint);
    
    final Paint bezelBorder = Paint()
      ..color = AppTheme.primary.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, lensRadius + 6, bezelBorder);

    // Glass Reflex Gradient
    final Rect lensRect = Rect.fromCircle(center: center, radius: lensRadius);
    final Paint glassPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF0F223D),
          Color(0xFF050E18),
        ],
        stops: [0.0, 1.0],
      ).createShader(lensRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, lensRadius, glassPaint);

    // Aperture Blades (geometric segments)
    final Paint bladePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    const int bladeCount = 6;
    for (int i = 0; i < bladeCount; i++) {
      final double angle = (i * 2 * math.pi / bladeCount) + (radarAngle * 0.05);
      final double x1 = center.dx + (lensRadius * 0.3) * math.cos(angle);
      final double y1 = center.dy + (lensRadius * 0.3) * math.sin(angle);
      final double x2 = center.dx + lensRadius * math.cos(angle + 0.5);
      final double y2 = center.dy + lensRadius * math.sin(angle + 0.5);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), bladePaint);
    }

    // Lens reflections / glints
    final Paint glintPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(lensRect)
      ..style = PaintingStyle.fill;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: lensRadius * 0.9), 
      -math.pi / 4, 
      math.pi / 3, 
      false, 
      glintPaint
    );

    // Inner glowing sensor lens / "red recording dot"
    final Paint sensorPaint = Paint()
      ..color = AppTheme.secondary.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, sensorPaint);
    
    final Paint sensorGlow = Paint()
      ..color = AppTheme.secondary.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12 * pulseScale, sensorGlow);

    // 4. Laser Scan Overlay Line (glowing green scanning laser sweep)
    final double laserY = center.dy - lensRadius + (2 * lensRadius * laserOffset);
    final double halfWidth = math.sqrt(math.max(0.0, lensRadius * lensRadius - math.pow(laserY - center.dy, 2)));
    if (halfWidth > 0) {
      final Paint laserPaint = Paint()
        ..color = AppTheme.secondary.withOpacity(0.8)
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(center.dx - halfWidth, laserY),
        Offset(center.dx + halfWidth, laserY),
        laserPaint,
      );
      
      // Laser bloom shadow
      final Paint laserBloom = Paint()
        ..color = AppTheme.secondary.withOpacity(0.2)
        ..strokeWidth = 8.0;
      canvas.drawLine(
        Offset(center.dx - halfWidth, laserY),
        Offset(center.dx + halfWidth, laserY),
        laserBloom,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RadarLensPainter oldDelegate) {
    return oldDelegate.radarAngle != radarAngle ||
        oldDelegate.pulseScale != pulseScale ||
        oldDelegate.laserOffset != laserOffset;
  }
}
