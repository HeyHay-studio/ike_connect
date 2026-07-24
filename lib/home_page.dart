import 'package:flutter/material.dart';

import 'responsive.dart';
import 'sections/contact_section.dart';
import 'sections/estimator_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/services_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/visualizer_section.dart';
import 'theme.dart';
import 'widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _detailsController = TextEditingController();

  // Keys to locate section offsets for smooth scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _visualizerKey = GlobalKey();
  final GlobalKey _estimatorKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _currentActiveLinkIndex = 0;
  String _estimateSummary = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Detect scroll offset to update active navbar section highlight
  void _onScroll() {
    final double offset = _scrollController.offset;
    int activeIndex = 0;

    // Approximate offsets based on general section heights
    if (offset >= 4200) {
      activeIndex = 5; // Contact
    } else if (offset >= 3500) {
      activeIndex = 4; // Reviews
    } else if (offset >= 2300) {
      activeIndex = 3; // Estimator
    } else if (offset >= 1400) {
      activeIndex = 2; // Schematic
    } else if (offset >= 600) {
      activeIndex = 1; // Services
    } else {
      activeIndex = 0; // Hero
    }

    if (_currentActiveLinkIndex != activeIndex) {
      setState(() {
        _currentActiveLinkIndex = activeIndex;
      });
    }
  }

  void _scrollTo(int index) {
    GlobalKey targetKey;
    switch (index) {
      case 0:
        targetKey = _heroKey;
        break;
      case 1:
        targetKey = _servicesKey;
        break;
      case 2:
        targetKey = _visualizerKey;
        break;
      case 3:
        targetKey = _estimatorKey;
        break;
      case 4:
        targetKey = _testimonialsKey;
        break;
      case 5:
        targetKey = _contactKey;
        break;
      default:
        targetKey = _heroKey;
    }

    if (targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleEstimateLocked(String summary) {
    setState(() {
      _estimateSummary = summary;
    });
    // Scroll down to contact section
    _scrollTo(5);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      endDrawer: isMobile ? _buildMobileDrawer() : null,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
            ),
          ),

          // Scrollable Sections
          Positioned.fill(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                // Navbar placeholder (since navbar is floating)
                const SizedBox(height: 80),

                // Hero Section
                Container(
                  key: _heroKey,
                  child: HeroSection(onCtaPressed: () => _scrollTo(5)),
                ),

                // Services
                Container(key: _servicesKey, child: const ServicesSection()),

                // Schematic Visualizer
                Container(
                  key: _visualizerKey,
                  child: const VisualizerSection(),
                ),

                // Quote Cost Estimator
                Container(
                  key: _estimatorKey,
                  child: EstimatorSection(
                    onEstimateLocked: _handleEstimateLocked,
                  ),
                ),

                // Reviews
                Container(
                  key: _testimonialsKey,
                  child: const TestimonialsSection(),
                ),

                // Booking Form
                Container(
                  key: _contactKey,
                  child: ContactSection(
                    prefilledDetails: _estimateSummary,
                    detailsController: _detailsController,
                  ),
                ),

                // Footer
                FooterSection(onScrollToContact: () => _scrollTo(5)),
              ],
            ),
          ),

          // Sticky Navbar floating over the content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(
              activeIndex: _currentActiveLinkIndex,
              onLinkPressed: _scrollTo,
              onCtaPressed: () => _scrollTo(5),
            ),
          ),
        ],
      ),
    );
  }

  // Hamburger Drawer for mobile screens
  Widget _buildMobileDrawer() {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Home', 'index': 0, 'icon': Icons.home_outlined},
      {'label': 'Services', 'index': 1, 'icon': Icons.business_outlined},
      {'label': 'Schematic', 'index': 2, 'icon': Icons.map_outlined},
      {'label': 'Estimator', 'index': 3, 'icon': Icons.calculate_outlined},
      {'label': 'Reviews', 'index': 4, 'icon': Icons.star_outline},
      {'label': 'Booking', 'index': 5, 'icon': Icons.lock_outline},
    ];

    return Drawer(
      backgroundColor: AppTheme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header Brand
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppTheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text('IKE CONNECT', style: AppTheme.headlineStyle(size: 20)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'SECURE ACCESS PROTOCOL',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Menu Links
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, idx) {
                    final item = menuItems[idx];
                    bool isSelected = _currentActiveLinkIndex == item['index'];
                    return ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      title: Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isSelected ? AppTheme.primary : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close Drawer
                        _scrollTo(item['index'] as int);
                      },
                    );
                  },
                ),
              ),

              // Mobile contact CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _scrollTo(5);
                  },
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: const Text('Contact Desk'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
