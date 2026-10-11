import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/doctor_model.dart';
import '../../models/appointment_model.dart';
import '../../services/appointment_service.dart';

class BookingSummaryScreen extends StatefulWidget {
  final String doctorId;
  final String date;
  final String slot;

  const BookingSummaryScreen({
    super.key,
    required this.doctorId,
    required this.date,
    required this.slot,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  late Doctor _doctor;
  final TextEditingController _promoController = TextEditingController();
  
  bool _isPromoApplied = false;
  double _discountAmount = 0.0;
  String _promoError = "";
  String _appliedPromoCode = "";

  // Base configurations
  final double _platformFee = 50.0;
  final double _vatRate = 0.05;

  @override
  void initState() {
    super.initState();
    _doctor = dummyDoctors.firstWhere(
      (doc) => doc.id == widget.doctorId,
      orElse: () => dummyDoctors[0],
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      if (code == "HEALTH50" || code == "FIRST50") {
        _isPromoApplied = true;
        _discountAmount = 50.0;
        _appliedPromoCode = code;
        _promoError = "";
      } else if (code == "SUPER100") {
        _isPromoApplied = true;
        _discountAmount = 100.0;
        _appliedPromoCode = code;
        _promoError = "";
      } else {
        _isPromoApplied = false;
        _discountAmount = 0.0;
        _appliedPromoCode = "";
        _promoError = "Invalid Promo Code";
      }
    });
  }

  void _removePromo() {
    setState(() {
      _isPromoApplied = false;
      _discountAmount = 0.0;
      _appliedPromoCode = "";
      _promoController.clear();
      _promoError = "";
    });
  }

  void _initiateMockPayment(String method) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    method == "bKash" ? Icons.phone_android_rounded : Icons.credit_card_rounded,
                    color: ClinicalTheme.primaryBlue,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$method Checkout',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Payment integration is coming soon. Would you like to proceed with our mock payment simulation to test the appointment scheduler?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: ClinicalTheme.textSecondary.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: ClinicalTheme.textSecondary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _processSuccessfulAppointment(method);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClinicalTheme.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Simulate Success', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processSuccessfulAppointment(String paymentMethod) {
    // Math summary
    final subtotal = _doctor.consultationFee;
    final vat = subtotal * _vatRate;
    final total = subtotal + vat + _platformFee - _discountAmount;
    final appId = 'APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final appointment = Appointment(
      id: appId,
      doctorId: _doctor.id,
      doctorName: _doctor.name,
      doctorDegrees: _doctor.degrees,
      doctorSpecialty: _doctor.specialty,
      date: widget.date,
      timeSlot: widget.slot,
      status: 'Upcoming',
      consultationFee: subtotal,
      vat: vat,
      platformFee: _platformFee,
      totalAmount: total,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    // Save to provider state
    Provider.of<AppointmentService>(context, listen: false).addAppointment(appointment);

    // Push to success page
    context.push('/booking-success?appId=$appId');
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _doctor.consultationFee;
    final vat = subtotal * _vatRate;
    final total = subtotal + vat + _platformFee - _discountAmount;

    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ClinicalTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor & Schedule confirmation card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                        child: Text(
                          _doctor.name.split(" ")[1][0],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ClinicalTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _doctor.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ClinicalTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              _doctor.degrees,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: ClinicalTheme.textSecondary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.withOpacity(0.08), height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: ClinicalTheme.primaryBlue, size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${widget.date} at ${widget.slot}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Promo code card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Have a promo code?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: ClinicalTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isPromoApplied)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified_rounded, color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Code "$_appliedPromoCode" Applied',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.green, size: 20),
                            onPressed: _removePromo,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        ],
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: ClinicalTheme.backgroundLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _promoController,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'Enter code (e.g. FIRST50)',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11.5),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _applyPromo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ClinicalTheme.primaryBlue,
                            elevation: 0,
                            fixedSize: const Size(80, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  if (_promoError.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _promoError,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: ClinicalTheme.alertRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bill Breakdown Details
            const Text(
              'Invoice Breakdown',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: ClinicalTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  _buildBillRow('Consultation Fee', subtotal),
                  const SizedBox(height: 10),
                  _buildBillRow('Govt. VAT (5%)', vat),
                  const SizedBox(height: 10),
                  _buildBillRow('Platform Charge', _platformFee),
                  if (_discountAmount > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Text(
                          'Promo Discount',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '- ৳ ${_discountAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text(
                        'Total Payable',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                      ),
                      Text(
                        '৳ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.extrabold,
                          color: ClinicalTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Select payment method buttons
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: ClinicalTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // bKash Button
            InkWell(
              onTap: () => _initiateMockPayment('bKash'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2125B).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2125B).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2125B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'bKash',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pay with bKash Wallet',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Instant digital verification',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: ClinicalTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFE2125B), size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card / Nagad / Visa Button
            InkWell(
              onTap: () => _initiateMockPayment('Card/SSLCommerz'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ClinicalTheme.primaryBlue.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ClinicalTheme.primaryBlue.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 50,
                      decoration: BoxDecoration(
                        color: ClinicalTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card / Nagad / SSLCommerz',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: ClinicalTheme.textDark,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Visa, Mastercard, Nagad or Rocket',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: ClinicalTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: ClinicalTheme.primaryBlue, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: ClinicalTheme.textSecondary),
        ),
        Text(
          '৳ ${val.toStringAsFixed(2)}',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: ClinicalTheme.textDark, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
