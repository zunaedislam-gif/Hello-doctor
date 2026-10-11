import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    // Find the doctor from the mock dataset
    final doctor = dummyDoctors.firstWhere(
      (doc) => doc.id == doctorId,
      orElse: () => dummyDoctors[0],
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: ClinicalTheme.backgroundLight,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // Collapsible custom App Bar with Doctor Header Profile
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                backgroundColor: innerBoxIsScrolled ? Colors.white : ClinicalTheme.backgroundLight,
                elevation: innerBoxIsScrolled ? 1 : 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClinicalTheme.textDark, size: 20),
                  onPressed: () => context.pop(),
                ),
                title: innerBoxIsScrolled
                    ? Text(
                        doctor.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ClinicalTheme.textDark,
                        ),
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor Large Avatar
                          Hero(
                            tag: 'avatar_${doctor.id}',
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: ClinicalTheme.primaryBlue.withOpacity(0.08),
                              child: Text(
                                doctor.name.split(" ")[1][0],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: ClinicalTheme.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Text credentials
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.extrabold,
                                    fontSize: 18,
                                    color: ClinicalTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doctor.degrees,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: ClinicalTheme.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        doctor.specialty,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color: ClinicalTheme.primaryBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      doctor.bmdcNumber,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 16),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${doctor.rating}",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ClinicalTheme.textDark,
                                      ),
                                    ),
                                    Text(
                                      " (${doctor.reviewsCount} Reviews)",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: ClinicalTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text("|", style: TextStyle(color: Colors.grey.shade300)),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${doctor.experience} yrs exp",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: ClinicalTheme.primaryBlue,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Sticky Segmented Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: ClinicalTheme.primaryBlue,
                    unselectedLabelColor: ClinicalTheme.textSecondary,
                    indicatorColor: ClinicalTheme.primaryBlue,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                    tabs: const [
                      Tab(text: "Info"),
                      Tab(text: "Experience"),
                      Tab(text: "Reviews"),
                      Tab(text: "Tips/Articles"),
                    ],
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              _buildInfoTab(doctor),
              _buildExperienceTab(doctor),
              _buildReviewsTab(doctor),
              _buildTipsTab(doctor),
            ],
          ),
        ),
        
        // Sticky Bottom Consultation Fee + Book Button Bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consultation Fee',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ClinicalTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '৳ ${doctor.consultationFee.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.extrabold,
                      color: ClinicalTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push(
                        '/chat-conversation?threadId=patient_${doctor.id}&peerId=${doctor.id}&peerName=${Uri.encodeComponent(doctor.name)}&peerRole=doctor',
                      );
                    },
                    tooltip: 'Send Message',
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: ClinicalTheme.primaryBlue, size: 20),
                    style: IconButton.styleFrom(
                      side: const BorderSide(color: ClinicalTheme.primaryBlue, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/booking-calendar?docId=${doctor.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClinicalTheme.primaryBlue,
                      elevation: 0,
                      minimumSize: const Size(140, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // 1. Info Tab Builder
  Widget _buildInfoTab(Doctor doc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio Section
          const Text(
            'About Doctor',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13.5, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 6),
          Text(
            doc.bio,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              color: ClinicalTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Detail Grid (Timing, Call Duration, etc)
          const Text(
            'Chamber & Consultation Details',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13.5, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 10),
          
          _buildInfoItemCard(
            Icons.access_time_filled_rounded,
            'Consultation Timing',
            doc.timing,
          ),
          const SizedBox(height: 10),
          _buildInfoItemCard(
            Icons.calendar_month_rounded,
            'Appointment Timing',
            doc.appointmentTiming,
          ),
          const SizedBox(height: 10),
          _buildInfoItemCard(
            Icons.phone_android_rounded,
            'Average Call Duration',
            doc.avgCallDuration,
          ),
          const SizedBox(height: 10),
          _buildInfoItemCard(
            Icons.price_change_rounded,
            'Follow-up Consultation Fee',
            '৳ ${doc.followUpFee.toStringAsFixed(0)} (valid within 15 days)',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoItemCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ClinicalTheme.primaryBlue.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ClinicalTheme.primaryBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ClinicalTheme.textDark,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 2. Experience Tab Builder (Custom Vertical Timeline)
  Widget _buildExperienceTab(Doctor doc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work & Academic History',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13.5, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doc.experienceList.length,
            itemBuilder: (context, index) {
              final exp = doc.experienceList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline column
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: ClinicalTheme.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: ClinicalTheme.primaryBlue.withOpacity(0.3),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                      if (index != doc.experienceList.length - 1)
                        Container(
                          width: 2,
                          height: 80,
                          color: ClinicalTheme.primaryBlue.withOpacity(0.2),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Timeline details card
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.hospitalName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${exp.position} — ${exp.department}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exp.duration,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: ClinicalTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  // 3. Reviews Tab Builder with bar-charts
  Widget _buildReviewsTab(Doctor doc) {
    final breakdown = doc.ratingBreakdown;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header overall breakdown card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${doc.rating}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.extrabold,
                        color: ClinicalTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      '${doc.reviewsCount} reviews',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ClinicalTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Horizontal Bars
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final val = breakdown[star] ?? 0.0;
                      return Row(
                        children: [
                          Text(
                            "$star",
                            style: const TextStyle(fontFamily: 'Inter', fontSize: 10.5, fontWeight: FontWeight.bold, color: ClinicalTheme.textDark),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 11),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: val,
                                minHeight: 6,
                                color: ClinicalTheme.primaryBlue,
                                backgroundColor: Colors.grey.shade100,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 26,
                            child: Text(
                              "${(val * 100).toStringAsFixed(0)}%",
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: ClinicalTheme.textSecondary),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Patient Reviews',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 13.5, color: ClinicalTheme.textDark),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doc.reviewsList.length,
            itemBuilder: (context, index) {
              final review = doc.reviewsList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          review.patientName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ClinicalTheme.textDark,
                          ),
                        ),
                        Text(
                          review.date,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            color: ClinicalTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Rating stars
                    Row(
                      children: List.generate(5, (starIdx) {
                        return Icon(
                          Icons.star_rate_rounded,
                          size: 13,
                          color: starIdx < review.rating.round()
                              ? Colors.amber
                              : Colors.grey.shade200,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: ClinicalTheme.textDark,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // 4. Tips/Articles Tab Builder
  Widget _buildTipsTab(Doctor doc) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: doc.tipsList.length,
      itemBuilder: (context, index) {
        final tip = doc.tipsList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ClinicalTheme.primaryBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tip.category.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: ClinicalTheme.primaryBlue,
                        ),
                      ),
                    ),
                    Text(
                      tip.readTime,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: ClinicalTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ClinicalTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip.snippet,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: ClinicalTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Read Full Article',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.blue.shade800),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// Sliver Persistent Header Delegate helper for tabs
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
