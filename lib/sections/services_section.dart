import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    // List of CCTV & security services offered by IKE Connect
    final List<Map<String, dynamic>> services = [
      {
        'icon': Icons.home_outlined,
        'title': 'Residential CCTV',
        'desc': 'Smart security solutions for your home. Keep watch on your property from anywhere in the world with high-definition cameras, night vision, and instant mobile alerts.',
        'features': ['1080p / 4K UHD Clarity', 'ColorNight™ Low Light Tech', 'Smart Home Integration'],
      },
      {
        'icon': Icons.business_outlined,
        'title': 'Commercial Surveillance',
        'desc': 'Secure your business assets, employees, and operations. High-capacity network storage, AI crowd heatmaps, plate reading, and centralized multisite dashboards.',
        'features': ['AI Human & Vehicle Detection', 'Multi-site Management', '24/7 High-Capacity NVR'],
      },
      {
        'icon': Icons.vpn_key_outlined,
        'title': 'Smart Access Control',
        'desc': 'Control who enters your premises. Integrated biometric locks, security gates, intercoms, and keyless access control solutions managed via cloud console.',
        'features': ['Fingerprint & Facial ID', 'Intercom with Video Feed', 'Automated Event Logging'],
      },
      {
        'icon': Icons.security_outlined,
        'title': '24/7 Support & Health Checks',
        'desc': 'Continuous uptime is critical. We offer remote camera health checks, automatic diagnostic warnings, data backups, and priority support dispatching.',
        'features': ['Remote Diagnostic Checks', 'Automatic Alert Failover', 'Fast Hardware Swap'],
      },
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.0 : 80.0,
        vertical: 80.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Sub-tag
          Text(
            'WHAT WE DO',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          
          // Section Title
          Text(
            'Advanced Surveillance Solutions',
            textAlign: TextAlign.center,
            style: AppTheme.headlineStyle(
              size: isMobile ? 28 : 38,
              isBold: true,
            ),
          ),
          const SizedBox(height: 16),
          
          // Section Subtext
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'IKE Connect supplies, installs, and maintains state-of-the-art security networks. We use AI-enhanced analytics to prevent threats before they unfold.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle(
                size: isMobile ? 14 : 16,
                isSecondary: true,
              ),
            ),
          ),
          const SizedBox(height: 60),
          
          // Responsive Grid of Cards
          isMobile
              ? Column(
                  children: services
                      .map((service) => Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: ServiceCard(service: service),
                          ))
                      .toList(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isTablet(context) ? 2 : 4,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(service: services[index]);
                  },
                ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -10, 0))
            : Matrix4.identity(),
        decoration: AppTheme.glassCard(
          borderOpacity: _isHovered ? 0.6 : 0.2,
          showGlow: _isHovered,
        ),
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Widget with animated glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppTheme.primary.withOpacity(0.2)
                    : AppTheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? AppTheme.primary.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Icon(
                widget.service['icon'] as IconData,
                color: _isHovered ? AppTheme.primary : AppTheme.textPrimary,
                size: 28,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              widget.service['title'] as String,
              style: AppTheme.headlineStyle(size: 20),
            ),
            const SizedBox(height: 12),
            
            // Description
            Expanded(
              child: Text(
                widget.service['desc'] as String,
                style: AppTheme.bodyStyle(size: 13, isSecondary: true),
                overflow: TextOverflow.fade,
              ),
            ),
            
            const SizedBox(height: 16),
            const Divider(color: Color(0x1F00E5FF), height: 1),
            const SizedBox(height: 16),
            
            // Bullet features
            Column(
              children: (widget.service['features'] as List<String>)
                  .map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: AppTheme.secondary,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: AppTheme.bodyStyle(size: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
