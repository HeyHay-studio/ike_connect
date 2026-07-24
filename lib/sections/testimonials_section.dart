import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, String>> testimonials = [
    {
      'quote': 'IKE Connect designed a perimeter security grid for our 40,000 sq ft logistics depot. Their smart AI cameras immediately identify any unauthorized yard entries, reducing false alarms to zero. Exceptional engineering.',
      'author': 'Marcus Vance',
      'role': 'Director of Logistics, Apex Transport',
      'rating': '5',
    },
    {
      'quote': 'We had 8 4K security nodes and facial entry panels fitted at our residential complex. The mobile app feed is lightning fast. I can check our gates, audit delivery entries, and configure access codes instantly.',
      'author': 'Sarah Jenkins',
      'role': 'HOA President, Oakridge Condominiums',
      'rating': '5',
    },
    {
      'quote': 'The installation crew was incredibly tidy and professional. Zero exposed cables, thorough staff training, and the cost estimation app online matched our final invoice exactly. Highly recommended security contractor.',
      'author': 'David Miller',
      'role': 'Founder, TechNexus coworking spaces',
      'rating': '5',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

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
          // Sub-tag
          Text(
            'TESTIMONIALS',
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
            'Trusted By Property Managers',
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
              'Here is what residential owners, business managers, and industrial logistics developers say about their IKE Connect security deployments.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle(
                size: isMobile ? 14 : 16,
                isSecondary: true,
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Slider Panel
          SizedBox(
            height: isMobile ? 360 : 280,
            child: Row(
              children: [
                // Previous Arrow
                if (!isMobile)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primary, size: 28),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.animateToPage(
                          _currentPage - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                  ),
                
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: testimonials.length,
                    onPageChanged: (idx) {
                      setState(() => _currentPage = idx);
                    },
                    itemBuilder: (context, index) {
                      final item = testimonials[index];
                      final bool isSelected = index == _currentPage;

                      return AnimatedScale(
                        scale: isSelected ? 1.0 : 0.95,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.4,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            padding: EdgeInsets.all(isMobile ? 24 : 32),
                            decoration: AppTheme.glassCard(
                              borderOpacity: isSelected ? 0.4 : 0.15,
                              showGlow: isSelected,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Stars
                                Row(
                                  children: List.generate(
                                    int.parse(item['rating']!),
                                    (i) => const Icon(Icons.star, color: AppTheme.secondary, size: 16),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Quote text
                                Expanded(
                                  child: Text(
                                    '"${item['quote']!}"',
                                    style: AppTheme.bodyStyle(
                                      size: isMobile ? 13 : 15,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Author details
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: AppTheme.primary,
                                      radius: 16,
                                      child: Icon(Icons.person, color: Colors.black, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['author']!,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                          item['role']!,
                                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Next Arrow
                if (!isMobile)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.primary, size: 28),
                    onPressed: () {
                      if (_currentPage < testimonials.length - 1) {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
          
          // Indicator Dots
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              testimonials.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: index == _currentPage ? AppTheme.primary : AppTheme.primary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
