import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class EstimatorSection extends StatefulWidget {
  final Function(String estimateSummary) onEstimateLocked;

  const EstimatorSection({super.key, required this.onEstimateLocked});

  @override
  State<EstimatorSection> createState() => _EstimatorSectionState();
}

class _EstimatorSectionState extends State<EstimatorSection> {
  // Calculator States
  String _propertyType = 'Home'; // Home, Business, Industrial
  double _cameraCount = 4;
  String _cameraQuality = '4K Bullet'; // 1080p, 4K Bullet, AI ColorNight
  int _storageDays = 30; // 30, 60, 90
  bool _accessControlSelected = false;
  bool _monitoringSelected = false;

  double _totalEstimate = 0.0;
  double _monthlySubscription = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculateTotal();
  }

  void _recalculateTotal() {
    double baseCost = 0;
    double cameraUnitCost = 0;
    double storageCost = 0;
    double addonsCost = 0;
    double monthlyFee = 0;

    // 1. Property Base Setup Cost
    switch (_propertyType) {
      case 'Home':
        baseCost = 150;
        break;
      case 'Business':
        baseCost = 350;
        break;
      case 'Industrial':
        baseCost = 650;
        break;
    }

    // 2. Camera Quality Unit Cost
    switch (_cameraQuality) {
      case '1080p Dome':
        cameraUnitCost = 130;
        break;
      case '4K Bullet':
        cameraUnitCost = 210;
        break;
      case 'AI ColorNight':
        cameraUnitCost = 290;
        break;
    }

    // 3. Storage Cost
    switch (_storageDays) {
      case 30:
        storageCost = 0;
        break;
      case 60:
        storageCost = 180;
        break;
      case 90:
        storageCost = 320;
        break;
    }

    // 4. Addons Cost
    if (_accessControlSelected) {
      addonsCost += 399; // flat gate integration hardware
    }
    if (_monitoringSelected) {
      monthlyFee += 49; // 24/7 monitoring
    }

    // Grand calculations
    setState(() {
      _totalEstimate = baseCost + (_cameraCount * cameraUnitCost) + storageCost + addonsCost;
      _monthlySubscription = monthlyFee;
    });
  }

  void _lockEstimateAndProceed() {
    final String summary = "Property: $_propertyType, "
        "Cameras: ${_cameraCount.round()}x $_cameraQuality, "
        "Storage: $_storageDays Days, "
        "Access Control: ${_accessControlSelected ? 'Yes' : 'No'}, "
        "24/7 Monitor: ${_monitoringSelected ? 'Yes' : 'No'}, "
        "Est: \$${_totalEstimate.round()} + \$${_monthlySubscription.round()}/mo";
    widget.onEstimateLocked(summary);
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
            'COST ESTIMATOR',
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
            'Build Your Security Package',
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
              'Customize your layout requirements, number of nodes, and smart additions. Get an instant equipment estimate and submit it directly to lock in a site survey discount.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle(
                size: isMobile ? 14 : 16,
                isSecondary: true,
              ),
            ),
          ),
          const SizedBox(height: 60),

          // Main Layout Wrapper
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Selection Controls
              Expanded(
                flex: isMobile ? 1 : 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Property Select
                    _buildSectionHeader('1. Property Type'),
                    const SizedBox(height: 12),
                    _buildPropertySelection(),
                    const SizedBox(height: 32),

                    // Step 2: Camera Slider
                    _buildSectionHeader('2. Camera Nodes: ${_cameraCount.round()} Cameras'),
                    const SizedBox(height: 12),
                    _buildCameraSlider(),
                    const SizedBox(height: 32),

                    // Step 3: Camera Quality
                    _buildSectionHeader('3. Camera Lens Quality'),
                    const SizedBox(height: 12),
                    _buildCameraQualityOptions(),
                    const SizedBox(height: 32),

                    // Step 4: Storage Select
                    _buildSectionHeader('4. Video Storage Retain Time'),
                    const SizedBox(height: 12),
                    _buildStorageOptions(),
                    const SizedBox(height: 32),

                    // Step 5: Addons
                    _buildSectionHeader('5. System Add-ons'),
                    const SizedBox(height: 12),
                    _buildAddonCheckboxes(),
                  ],
                ),
              ),

              if (isMobile) const SizedBox(height: 40) else const SizedBox(width: 50),

              // Right side: Price output card
              Expanded(
                flex: isMobile ? 1 : 4,
                child: StickyPriceCard(
                  totalPrice: _totalEstimate,
                  monthlyPrice: _monthlySubscription,
                  cameraCount: _cameraCount.round(),
                  cameraQuality: _cameraQuality,
                  storageDays: _storageDays,
                  propertyType: _propertyType,
                  onBookPressed: _lockEstimateAndProceed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.headlineStyle(size: 16),
    );
  }

  // Row of Property selectors
  Widget _buildPropertySelection() {
    final List<Map<String, String>> types = [
      {'val': 'Home', 'label': 'Residential', 'icon': 'house'},
      {'val': 'Business', 'label': 'Commercial Office', 'icon': 'business'},
      {'val': 'Industrial', 'label': 'Industrial / Depot', 'icon': 'warehouse'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: types.map((t) {
        bool selected = _propertyType == t['val'];
        IconData iconData = t['val'] == 'Home'
            ? Icons.home_outlined
            : t['val'] == 'Business'
                ? Icons.business_center_outlined
                : Icons.warehouse_outlined;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() => _propertyType = t['val']!);
              _recalculateTotal();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary.withOpacity(0.12) : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppTheme.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, color: selected ? AppTheme.primary : AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    t['label']!,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Camera node slider
  Widget _buildCameraSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: AppTheme.primary,
          inactiveTrackColor: AppTheme.background,
          thumbColor: AppTheme.primary,
          overlayColor: AppTheme.primary.withOpacity(0.2),
          valueIndicatorColor: AppTheme.primary,
          valueIndicatorTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        child: Slider(
          value: _cameraCount,
          min: 1,
          max: 32,
          divisions: 31,
          label: '${_cameraCount.round()} cams',
          onChanged: (val) {
            setState(() => _cameraCount = val);
            _recalculateTotal();
          },
        ),
      ),
    );
  }

  // Camera Quality selector chips
  Widget _buildCameraQualityOptions() {
    final List<Map<String, dynamic>> options = [
      {'val': '1080p Dome', 'title': '1080p Dome', 'desc': 'Good indoor clarity', 'price': '+\$130/ea'},
      {'val': '4K Bullet', 'title': '4K AI Bullet', 'desc': 'Ultra UHD, Outdoor deterrant', 'price': '+\$210/ea'},
      {'val': 'AI ColorNight', 'title': 'AI ColorNight', 'desc': 'Active night vision tracking', 'price': '+\$290/ea'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((opt) {
        bool selected = _cameraQuality == opt['val'];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() => _cameraQuality = opt['val'] as String);
              _recalculateTotal();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary.withOpacity(0.12) : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppTheme.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt['title'] as String,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt['desc'] as String,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opt['price'] as String,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Storage option buttons
  Widget _buildStorageOptions() {
    final List<Map<String, dynamic>> options = [
      {'days': 30, 'title': '30 Days', 'desc': 'Standard HDD storage', 'price': 'Included'},
      {'days': 60, 'title': '60 Days', 'desc': 'High durability SSD', 'price': '+\$180'},
      {'days': 90, 'title': '90 Days', 'desc': 'Dual drive + Cloud Sync', 'price': '+\$320'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((opt) {
        bool selected = _storageDays == opt['days'];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() => _storageDays = opt['days'] as int);
              _recalculateTotal();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary.withOpacity(0.12) : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppTheme.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt['title'] as String,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt['desc'] as String,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opt['price'] as String,
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // System Addon Switches/Checkboxes
  Widget _buildAddonCheckboxes() {
    return Column(
      children: [
        // Smart Access Control Checkbox
        _buildCheckboxTile(
          value: _accessControlSelected,
          title: 'Integrated Access Control System',
          desc: 'Connect biometric door scanners, turnstiles, or garage controllers (+ \$399 hardware)',
          onChanged: (val) {
            setState(() => _accessControlSelected = val ?? false);
            _recalculateTotal();
          },
        ),
        const SizedBox(height: 12),
        // Active Remote Monitoring
        _buildCheckboxTile(
          value: _monitoringSelected,
          title: '24/7 Active AI Monitoring Service',
          desc: 'Our monitoring desk screens system faults and issues dispatch notifications (+ \$49/month)',
          onChanged: (val) {
            setState(() => _monitoringSelected = val ?? false);
            _recalculateTotal();
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required String title,
    required String desc,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: value,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        activeColor: AppTheme.primary,
        checkColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onChanged: onChanged,
      ),
    );
  }
}

// Side Card displaying calculated totals and call to actions
class StickyPriceCard extends StatelessWidget {
  final double totalPrice;
  final double monthlyPrice;
  final int cameraCount;
  final String cameraQuality;
  final int storageDays;
  final String propertyType;
  final VoidCallback onBookPressed;

  const StickyPriceCard({
    super.key,
    required this.totalPrice,
    required this.monthlyPrice,
    required this.cameraCount,
    required this.cameraQuality,
    required this.storageDays,
    required this.propertyType,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: AppTheme.glassCard(
        borderOpacity: 0.35,
        showGlow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PACKAGE ESTIMATE',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          // Total price counter layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${totalPrice.round()}',
                style: AppTheme.headlineStyle(size: 42, isBold: true),
              ),
              const SizedBox(width: 8),
              const Text(
                'hardware & setup',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),

          if (monthlyPrice > 0) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '+\$${monthlyPrice.round()}',
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '/month service',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          const Divider(color: Color(0x3300E5FF)),
          const SizedBox(height: 24),

          // Spec Summary Checkpoints
          _buildSummaryRow(Icons.business, '$propertyType Installation'),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.videocam, '$cameraCount x $cameraQuality Nodes'),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.storage, '$storageDays Days Storage Drive'),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.engineering, 'Free Site Engineering Survey'),

          const SizedBox(height: 32),

          // Submit Action
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onBookPressed,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: AppTheme.techGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Apply Estimate To Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'No obligation. Estimates lock in special web discounts.',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
