import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../responsive.dart';

class ContactSection extends StatefulWidget {
  final String prefilledDetails;
  final TextEditingController detailsController;

  const ContactSection({
    super.key,
    required this.prefilledDetails,
    required this.detailsController,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Biometric Scan state
  bool _isScanning = false;
  bool _scanComplete = false;
  String _scanStatusText = 'INITIALIZING ENCRYPTED CONNECTION...';
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(covariant ContactSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prefilledDetails != oldWidget.prefilledDetails) {
      widget.detailsController.text = widget.prefilledDetails;
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _triggerBiometricScan() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isScanning = true;
      _scanComplete = false;
      _scanStatusText = 'ESTABLISHING SECURE PROTOCOLS...';
    });

    _scannerController.repeat(reverse: true);

    // Simulated secure telemetry steps
    Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _scanStatusText = 'ENCRYPTING TRANSMISSION PAYLOAD (AES-256)...');
      }
    });

    Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() => _scanStatusText = 'VERIFYING DATA SHA-256 HASH INTEGRITY...');
      }
    });

    Timer(const Duration(milliseconds: 2100), () {
      if (mounted) {
        setState(() => _scanStatusText = 'UPLOADING SECURE PACKETS TO CLOUD...');
      }
    });

    // Complete transmission
    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _scannerController.stop();
        setState(() {
          _isScanning = false;
          _scanComplete = true;
        });
        
        // Reset form inputs after successful booking
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        widget.detailsController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

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
            'SECURE BOOKING',
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
            'Schedule Your Site Assessment',
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
              'Submit a security inquiry, and our field technicians will visit for a detailed site surveillance blueprint. All communication is secured via end-to-end encryption.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyStyle(
                size: isMobile ? 14 : 16,
                isSecondary: true,
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Main Form Card
          Container(
            constraints: const BoxConstraints(maxWidth: 680),
            decoration: AppTheme.glassCard(
              borderOpacity: 0.3,
              showGlow: true,
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // 1. Standard Input Form
                Padding(
                  padding: EdgeInsets.all(isMobile ? 24.0 : 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lock_outline, color: AppTheme.primary, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Encrypted Consultation Request Form',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Form Fields (Name & Phone in a row for Desktop)
                        if (!isMobile)
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_nameController, 'Full Name', Icons.person_outline)),
                              const SizedBox(width: 20),
                              Expanded(child: _buildTextField(_phoneController, 'Phone Number', Icons.phone_android_outlined)),
                            ],
                          )
                        else ...[
                          _buildTextField(_nameController, 'Full Name', Icons.person_outline),
                          const SizedBox(height: 20),
                          _buildTextField(_phoneController, 'Phone Number', Icons.phone_android_outlined),
                        ],
                        const SizedBox(height: 20),

                        // Email
                        _buildTextField(_emailController, 'Email Address', Icons.mail_outline, isEmail: true),
                        const SizedBox(height: 20),

                        // Project Notes / Calculator Pre-fill
                        _buildTextField(
                          widget.detailsController,
                          'Project Details (Specify site requirements or camera count)',
                          Icons.description_outlined,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),

                        // Submission Button
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _triggerBiometricScan,
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fingerprint, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Secure Biometric Submission',
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
                      ],
                    ),
                  ),
                ),

                // 2. Encryption Scanner Overlay (Shown when submitting)
                if (_isScanning)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.92),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Glowing Fingerprint Node
                          AnimatedBuilder(
                            animation: _scannerController,
                            builder: (context, child) {
                              final double scanPos = _scannerController.value;
                              return Container(
                                width: 140,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.fingerprint,
                                      size: 100,
                                      color: AppTheme.primary,
                                    ),
                                    // Moving green scanner line
                                    Positioned(
                                      top: 10 + (160 * scanPos),
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        height: 3,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.secondary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.secondary,
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Telemetry text
                          Text(
                            _scanStatusText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontFamily: 'Courier',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              color: AppTheme.primary,
                              backgroundColor: AppTheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 3. Scan success screen
                if (_scanComplete)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.92),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success Ring
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.secondary, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.secondary.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppTheme.secondary,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          const Text(
                            'TRANSMISSION SECURELY COMPLETED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          const Text(
                            'IKE Connect Security Desk has registered your payload.\nWe will reach you within 2 hours to confirm your survey.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _scanComplete = false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.surface,
                              foregroundColor: AppTheme.primary,
                              side: const BorderSide(color: AppTheme.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Back to Form'),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData prefixIcon, {
    bool isEmail = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (isEmail) {
          final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailReg.hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        floatingLabelStyle: const TextStyle(color: AppTheme.primary),
        prefixIcon: Icon(prefixIcon, color: AppTheme.primary.withOpacity(0.7)),
        filled: true,
        fillColor: AppTheme.background.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
