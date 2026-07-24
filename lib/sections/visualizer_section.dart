import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class VisualizerSection extends StatefulWidget {
  const VisualizerSection({super.key});

  @override
  State<VisualizerSection> createState() => _VisualizerSectionState();
}

class _VisualizerSectionState extends State<VisualizerSection> with TickerProviderStateMixin {
  int _selectedNodeIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _lineDrawingController;

  // Nodes on the security blueprint
  final List<Map<String, dynamic>> securityNodes = [
    {
      'title': 'Front Gate Access Control',
      'device': 'AI Facial Recognition Scanner & Intercom',
      'specs': 'Dual lenses, 3D face structure check, IP66 waterproof, biometric door unlock release.',
      'status': 'Secure',
      'icon': Icons.lock_person_outlined,
      'x': 0.15, // relative X on canvas (0.0 to 1.0)
      'y': 0.65, // relative Y on canvas
    },
    {
      'title': 'Driveway Camera',
      'device': '4K AI Active Deterrence Bullet CCTV',
      'specs': 'ColorNight low-light viewing, active strobelight deterrence, red-blue warning flashing, human detection.',
      'status': 'Active Monitoring',
      'icon': Icons.videocam_outlined,
      'x': 0.35,
      'y': 0.25,
    },
    {
      'title': 'Main Office Hub',
      'device': 'Smart Dome Security Camera & Air Sensor',
      'specs': 'Ultra-wide 180° view, built-in mic, motion tracking, glass-break acoustic analyzer.',
      'status': 'Active Monitoring',
      'icon': Icons.visibility_outlined,
      'x': 0.6,
      'y': 0.55,
    },
    {
      'title': 'Network Server Closet',
      'device': 'IKE Connect Core NVR (Network Video Recorder)',
      'specs': '16-channel PoE, 16TB secure local storage, automated cloud backup replication, AI analytics engine.',
      'status': 'Central Server OK',
      'icon': Icons.dns_outlined,
      'x': 0.82,
      'y': 0.40,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _lineDrawingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _lineDrawingController.dispose();
    super.dispose();
  }

  void _onNodeSelected(int index) {
    if (_selectedNodeIndex != index) {
      setState(() {
        _selectedNodeIndex = index;
      });
      _lineDrawingController.reset();
      _lineDrawingController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final selectedNode = securityNodes[_selectedNodeIndex];

    return Container(
      width: double.infinity,
      color: AppTheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.0 : 80.0,
        vertical: 80.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sub-tag
          Text(
            'INTERACTIVE SCHEMATIC',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            'Live Security System Integration',
            textAlign: TextAlign.center,
            style: AppTheme.headlineStyle(
              size: isMobile ? 28 : 38,
              isBold: true,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtext
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Click the hotspots below to see how our surveillance cameras and smart entry devices stream back securely to your central IKE Connect Network Video Recorder.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle(
                size: isMobile ? 14 : 16,
                isSecondary: true,
              ),
            ),
          ),
          const SizedBox(height: 50),
          
          // Layout
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Blueprint / Map Canvas
              Expanded(
                flex: isMobile ? 1 : 7,
                child: AspectRatio(
                  aspectRatio: 1.6, // standard widescreen ratio
                  child: Container(
                    decoration: AppTheme.glassCard(
                      borderOpacity: 0.15,
                      color: AppTheme.background.withOpacity(0.5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        // Sci-fi Floor plan backdrop
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_pulseController, _lineDrawingController]),
                            builder: (context, child) {
                              return CustomPaint(
                                painter: BlueprintPainter(
                                  nodes: securityNodes,
                                  selectedIndex: _selectedNodeIndex,
                                  pulseVal: _pulseController.value,
                                  drawProgress: _lineDrawingController.value,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Interactive Node Buttons Overlay
                        ...securityNodes.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var node = entry.value;
                          bool isSelected = idx == _selectedNodeIndex;

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final double posX = node['x'] * constraints.maxWidth;
                              final double posY = node['y'] * constraints.maxHeight;

                              return Positioned(
                                left: posX - 24,
                                top: posY - 24,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _onNodeSelected(idx),
                                    child: AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? AppTheme.primary.withOpacity(0.2)
                                                : Colors.black.withOpacity(0.6),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppTheme.primary
                                                  : AppTheme.primary.withOpacity(0.4),
                                              width: isSelected ? 2.5 : 1.5,
                                            ),
                                            boxShadow: [
                                              if (isSelected)
                                                BoxShadow(
                                                  color: AppTheme.primary.withOpacity(0.4),
                                                  blurRadius: 12 + (_pulseController.value * 8),
                                                  spreadRadius: 1 + (_pulseController.value * 3),
                                                ),
                                            ],
                                          ),
                                          child: Icon(
                                            node['icon'] as IconData,
                                            color: isSelected ? Colors.white : AppTheme.primary.withOpacity(0.8),
                                            size: 22,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              if (isMobile) const SizedBox(height: 30) else const SizedBox(width: 40),

              // Right: Spec description card
              Expanded(
                flex: isMobile ? 1 : 4,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 340),
                  padding: const EdgeInsets.all(32),
                  decoration: AppTheme.glassCard(
                    borderOpacity: 0.3,
                    showGlow: true,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Node Status Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.secondary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedNode['status'] as String,
                              style: const TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Node Title
                      Text(
                        selectedNode['title'] as String,
                        style: AppTheme.headlineStyle(size: 22),
                      ),
                      const SizedBox(height: 8),
                      
                      // Device Name
                      Text(
                        selectedNode['device'] as String,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0x2200E5FF)),
                      const SizedBox(height: 16),
                      
                      // Specs Text
                      Text(
                        selectedNode['specs'] as String,
                        style: AppTheme.bodyStyle(size: 14, isSecondary: true),
                      ),
                      const SizedBox(height: 28),
                      
                      // Help tip
                      const Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppTheme.primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Click other blue hotspots to inspect node data paths.',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// BlueprintPainter draws blueprint-style layouts and data flow lines
class BlueprintPainter extends CustomPainter {
  final List<Map<String, dynamic>> nodes;
  final int selectedIndex;
  final double pulseVal;
  final double drawProgress;

  BlueprintPainter({
    required this.nodes,
    required this.selectedIndex,
    required this.pulseVal,
    required this.drawProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.06)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 1. Draw architectural grid lines
    const double sizeGrid = 30.0;
    for (double i = 0; i < size.width; i += sizeGrid) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double j = 0; j < size.height; j += sizeGrid) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), linePaint);
    }

    // 2. Draw mock floor-plan rooms/boundaries
    final Paint structurePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rectOuter = Rect.fromLTRB(15, 15, size.width - 15, size.height - 15);
    canvas.drawRect(rectOuter, structurePaint);

    // Internal dividers (blueprint look)
    canvas.drawLine(Offset(size.width * 0.3, 15), Offset(size.width * 0.3, size.height * 0.7), structurePaint);
    canvas.drawLine(Offset(size.width * 0.3, size.height * 0.7), Offset(size.width * 0.75, size.height * 0.7), structurePaint);
    canvas.drawLine(Offset(size.width * 0.55, 15), Offset(size.width * 0.55, size.height * 0.7), structurePaint);
    canvas.drawLine(Offset(size.width * 0.75, size.height * 0.3), Offset(size.width - 15, size.height * 0.3), structurePaint);
    canvas.drawLine(Offset(size.width * 0.75, size.height * 0.3), Offset(size.width * 0.75, size.height - 15), structurePaint);

    // 3. Draw central network hub (NVR Closet is at Index 3)
    final Offset hubOffset = Offset(
      nodes[3]['x'] * size.width,
      nodes[3]['y'] * size.height,
    );

    // Draw concentric data range circles radiating from the Hub
    final Paint hubRingsPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppTheme.primary.withOpacity(0.04 + (1 - pulseVal) * 0.06)
      ..strokeWidth = 1;
    canvas.drawCircle(hubOffset, 40 + (pulseVal * 80), hubRingsPaint);
    canvas.drawCircle(hubOffset, 100 + (pulseVal * 120), hubRingsPaint);

    // 4. Draw stream lines from all active nodes back to the server Hub (Index 3)
    for (int i = 0; i < nodes.length - 1; i++) {
      final bool isCurrent = i == selectedIndex;
      final Offset nodeOffset = Offset(
        nodes[i]['x'] * size.width,
        nodes[i]['y'] * size.height,
      );

      // Data connection stream path
      final Path path = Path();
      path.moveTo(nodeOffset.dx, nodeOffset.dy);
      
      // To look like neat cable trays, draw horizontal-first (orthogonal) lines
      final double midX = (nodeOffset.dx + hubOffset.dx) / 2;
      path.lineTo(midX, nodeOffset.dy);
      path.lineTo(midX, hubOffset.dy);
      path.lineTo(hubOffset.dx, hubOffset.dy);

      // Draw baseline passive cable path
      final Paint cablePaint = Paint()
        ..color = isCurrent 
            ? AppTheme.primary.withOpacity(0.3) 
            : AppTheme.primary.withOpacity(0.08)
        ..strokeWidth = isCurrent ? 2.0 : 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, cablePaint);

      // Draw moving packets / signals along the active path
      if (isCurrent) {
        final pathMetrics = path.computeMetrics();
        for (var metric in pathMetrics) {
          final double length = metric.length;
          final double currentDraw = length * drawProgress;
          
          // Draw the illuminated glowing tip of the line drawing
          final Path extract = metric.extractPath(0.0, currentDraw);
          
          final Paint activeLaserGlow = Paint()
            ..color = AppTheme.primary.withOpacity(0.2)
            ..strokeWidth = 6.0
            ..style = PaintingStyle.stroke;
          canvas.drawPath(extract, activeLaserGlow);

          final Paint activeLaserPaint = Paint()
            ..color = AppTheme.primary
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke;
          canvas.drawPath(extract, activeLaserPaint);

          // Moving dot data packet
          final double progressOffset = (pulseVal * length) % length;
          final tangent = metric.getTangentForOffset(progressOffset);
          if (tangent != null) {
            final Paint packetPaint = Paint()
              ..color = AppTheme.secondary
              ..style = PaintingStyle.fill;
            canvas.drawCircle(tangent.position, 4, packetPaint);
            
            // Halo glow
            canvas.drawCircle(
              tangent.position, 
              10, 
              Paint()
                ..color = AppTheme.secondary.withOpacity(0.2)
                ..style = PaintingStyle.fill
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant BlueprintPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.pulseVal != pulseVal ||
        oldDelegate.drawProgress != drawProgress;
  }
}
