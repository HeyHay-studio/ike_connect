import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onScrollToContact;

  const FooterSection({super.key, required this.onScrollToContact});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: EdgeInsets.only(
        left: isMobile ? 20.0 : 80.0,
        right: isMobile ? 20.0 : 80.0,
        top: 80.0,
        bottom: 30.0,
      ),
      child: Column(
        children: [
          const Divider(color: Color(0x1F00E5FF)),
          const SizedBox(height: 50),

          // Main footer columns
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column 1: Brand details
              Expanded(
                flex: isMobile ? 0 : 4,
                child: Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppTheme.primary, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'IKE CONNECT',
                          style: AppTheme.headlineStyle(size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Designing, deploying, and maintaining advanced CCTV neural grids and smart lock systems globally. Insured, licensed, and trusted since 2018.',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: AppTheme.bodyStyle(size: 13, isSecondary: true),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              if (isMobile) const SizedBox(height: 30) else const SizedBox(width: 40),

              // Column 2: Quick Links
              Expanded(
                flex: isMobile ? 0 : 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLinkCol('SERVICES', [
                      'Residential CCTV',
                      'Commercial Systems',
                      'Access Control',
                      'Maintenance Plans'
                    ]),
                    _buildLinkCol('COMPANY', [
                      'About Us',
                      'Case Studies',
                      'Certifications',
                      'Support Desk'
                    ]),
                  ],
                ),
              ),

              if (isMobile) const SizedBox(height: 30) else const SizedBox(width: 40),

              // Column 3: Newsletter Sign up
              Expanded(
                flex: isMobile ? 0 : 3,
                child: Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NEWSLETTER SUBSCRIPTION',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign up for monthly security threat assessments and product updates.',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: AppTheme.bodyStyle(size: 12, isSecondary: true),
                    ),
                    const SizedBox(height: 16),
                    
                    // Input Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline, color: AppTheme.primary, size: 16),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_outlined, color: AppTheme.primary),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),
          const Divider(color: Color(0x1300E5FF)),
          const SizedBox(height: 20),

          // Bottom Bar
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 IKE Connect Ltd. All Security Feeds Encrypted.',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
              if (isMobile) const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.security),
                  _buildSocialIcon(Icons.privacy_tip_outlined),
                  _buildSocialIcon(Icons.terminal_outlined),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCol(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  link,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(icon, color: AppTheme.textSecondary, size: 16),
      ),
    );
  }
}
