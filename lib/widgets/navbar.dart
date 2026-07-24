import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final int activeIndex;
  final Function(int) onLinkPressed;
  final VoidCallback onCtaPressed;

  const Navbar({
    super.key,
    required this.activeIndex,
    required this.onLinkPressed,
    required this.onCtaPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      height: 80.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(
            color: Color(0x1F00E5FF),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.0 : 80.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Brand Name
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onLinkPressed(0),
              child: Row(
                children: [
                  const AnimatedSecurityLogo(),
                  const SizedBox(width: 10),
                  Text(
                    'IKE CONNECT',
                    style: AppTheme.headlineStyle(size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Desktop Links
          if (!isMobile)
            Row(
              children: [
                _buildNavLink('Home', 0, activeIndex == 0),
                _buildNavLink('Services', 1, activeIndex == 1),
                _buildNavLink('Schematic', 2, activeIndex == 2),
                _buildNavLink('Estimator', 3, activeIndex == 3),
                _buildNavLink('Reviews', 4, activeIndex == 4),
                _buildNavLink('Booking', 5, activeIndex == 5),
                const SizedBox(width: 32),
                
                // Active CTA Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onCtaPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.techGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Text(
                        'Secure Call',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Hamburger button for mobile
            IconButton(
              icon: const Icon(Icons.menu_outlined, color: AppTheme.primary, size: 28),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text, int index, bool isSelected) {
    return NavLinkItem(
      text: text,
      isSelected: isSelected,
      onTap: () => onLinkPressed(index),
    );
  }
}

// Stateful NavLinkItem to handle hover state & draw line animations
class NavLinkItem extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const NavLinkItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavLinkItem> createState() => _NavLinkItemState();
}

class _NavLinkItemState extends State<NavLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.isSelected
                      ? AppTheme.primary
                      : (_isHovered ? Colors.white : AppTheme.textSecondary),
                  fontSize: 14,
                  fontWeight: widget.isSelected || _isHovered
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              // Animated indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: widget.isSelected ? 24 : (_isHovered ? 12 : 0),
                height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    if (widget.isSelected || _isHovered)
                      const BoxShadow(
                        color: AppTheme.primary,
                        blurRadius: 4,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Security Logo
class AnimatedSecurityLogo extends StatefulWidget {
  const AnimatedSecurityLogo({super.key});

  @override
  State<AnimatedSecurityLogo> createState() => _AnimatedSecurityLogoState();
}

class _AnimatedSecurityLogoState extends State<AnimatedSecurityLogo> with SingleTickerProviderStateMixin {
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.linear),
      ),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primary.withOpacity(0.08),
          border: Border.all(color: AppTheme.primary.withOpacity(0.4), width: 1.5),
        ),
        child: const Center(
          child: Icon(
            Icons.shield_outlined,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
