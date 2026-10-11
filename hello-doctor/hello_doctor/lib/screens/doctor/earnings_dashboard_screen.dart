import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class EarningsDashboardScreen extends StatefulWidget {
  const EarningsDashboardScreen({super.key});

  @override
  State<EarningsDashboardScreen> createState() => _EarningsDashboardScreenState();
}

class _EarningsDashboardScreenState extends State<EarningsDashboardScreen> {
  // Simulated transactions
  final List<Map<String, dynamic>> _transactions = [
    {
      "id": "TXN_4821",
      "patientName": "Karim Uddin",
      "date": "Today, 10:45 AM",
      "type": "Video Consultation",
      "amount": 500.00,
      "status": "Settled"
    },
    {
      "id": "TXN_4819",
      "patientName": "Sultana Yasmin",
      "date": "Today, 11:30 AM",
      "type": "Follow-up",
      "amount": 400.00,
      "status": "Settled"
    },
    {
      "id": "TXN_4799",
      "patientName": "Asif Iqbal",
      "date": "Yesterday, 12:15 PM",
      "type": "Video Consultation",
      "amount": 500.00,
      "status": "Settled"
    },
    {
      "id": "TXN_4760",
      "patientName": "Kamrul Hassan",
      "date": "02 Jul 2026, 06:00 PM",
      "type": "Video Consultation",
      "amount": 600.00,
      "status": "Settled"
    },
    {
      "id": "TXN_4754",
      "patientName": "Maliha Chowdhury",
      "date": "01 Jul 2026, 04:30 PM",
      "type": "On-demand Consult",
      "amount": 500.00,
      "status": "Settled"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicalTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Financial Analytics',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: ClinicalTheme.textDark,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stats row
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Today\'s Earning',
                    '৳ 3,200',
                    '4 Consultation fees',
                    Icons.payments_rounded,
                    Colors.emerald,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Consulted Today',
                    '4 Patients',
                    '3 Scheduled • 1 On-demand',
                    Icons.people_outline_rounded,
                    ClinicalTheme.primaryBlue,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // 2. fl_chart Bar Chart Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Earnings Comparison',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ClinicalTheme.textDark,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Current month vs previous month',
                              style: TextStyle(fontSize: 11, color: ClinicalTheme.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ClinicalTheme.primaryBlue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '+25.7% Growth',
                            style: TextStyle(
                              color: ClinicalTheme.primaryBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceEvenly,
                          maxY: 45000,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => ClinicalTheme.textDark.withOpacity(0.9),
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '৳${rod.toY.toInt()}',
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                    color: ClinicalTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  );
                                  Widget text;
                                  if (value == 0) {
                                    text = const Text('Previous Month', style: style);
                                  } else if (value == 1) {
                                    text = const Text('This Month', style: style);
                                  } else {
                                    text = const Text('', style: style);
                                  }
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 8,
                                    child: text,
                                  );
                                },
                                reservedSize: 28,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value % 15000 == 0 && value > 0) {
                                    return Text(
                                      '৳${(value / 1000).toStringAsFixed(0)}k',
                                      style: const TextStyle(color: Colors.grey, fontSize: 9.5),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                reservedSize: 32,
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade100,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: 31000,
                                  color: Colors.grey.shade300,
                                  width: 44,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                )
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: 39000,
                                  color: ClinicalTheme.primaryBlue,
                                  width: 44,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(Colors.grey.shade400, 'Prev Month (৳ 31,000)'),
                        const SizedBox(width: 20),
                        _buildLegend(ClinicalTheme.primaryBlue, 'This Month (৳ 39,000)'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Transactions title
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: ClinicalTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Transactions list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final txn = _transactions[index];

                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.emerald.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_downward_rounded, color: Colors.emerald, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txn['patientName'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: ClinicalTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${txn['type']} • ${txn['date']}',
                                style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+৳${(txn['amount'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.extrabold,
                                color: Colors.emerald,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              txn['status'] as String,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String sub, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.extrabold,
                fontSize: 20,
                color: ClinicalTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: ClinicalTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(fontSize: 9.5, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: ClinicalTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
