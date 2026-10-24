import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ExpenseModel>('expenses').listenable(),
        builder: (context, Box<ExpenseModel> box, _) {
          final expenses = box.values.toList().cast<ExpenseModel>();

          // Category totals
          final Map<String, double> categoryTotals = {};
          double total = 0;

          for (var expense in expenses) {
            categoryTotals[expense.category] =
                (categoryTotals[expense.category] ?? 0) + expense.amount;
            total += expense.amount;
          }

          // Highest category
          String highestCategory = 'None';
          double highestAmount = 0;

          categoryTotals.forEach((category, amount) {
            if (amount > highestAmount) {
              highestAmount = amount;
              highestCategory = category;
            }
          });

          final colors = [
            Colors.blue,
            Colors.purple,
            Colors.orange,
            Colors.green,
            Colors.red,
            Colors.teal,
            Colors.indigo,
            Colors.pink,
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== SUMMARY CARDS =====
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        'Total',
                        '₹${total.toStringAsFixed(0)}',
                        Icons.account_balance_wallet,
                        const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        'Highest',
                        highestCategory,
                        Icons.trending_up,
                        const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  'Spending Distribution',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ===== PIE CHART =====
                Container(
                  height: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: expenses.isEmpty
                      ? const Center(
                    child: Text('No data for chart'),
                  )
                      : PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: categoryTotals.entries.map((entry) {
                        final index = categoryTotals.keys.toList().indexOf(entry.key);
                        final percentage = total == 0
                            ? 0
                            : (entry.value / total * 100);

                        return PieChartSectionData(
                          color: colors[index % colors.length],
                          value: entry.value,
                          title: '${percentage.toStringAsFixed(0)}%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ===== CATEGORY BREAKDOWN =====
                const Text(
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...categoryTotals.entries.map((entry) {
                  final percentage = total == 0
                      ? 0
                      : (entry.value / total * 100);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: colors[categoryTotals.keys.toList().indexOf(entry.key) % colors.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${entry.value.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            colors[categoryTotals.keys.toList().indexOf(entry.key) % colors.length],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}