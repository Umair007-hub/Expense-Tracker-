import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';
import '../utils/premium_snackbar.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Travel':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Medicine':
        return Icons.local_hospital_rounded;
      case 'Education':
        return Icons.school_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFF5F3FF),
              Color(0xFFEEF2FF),
              Color(0xFFFDF4FF),
            ],
          ),
        ),

        child: ValueListenableBuilder(
          valueListenable: Hive.box<ExpenseModel>('expenses').listenable(),
          builder: (context, Box<ExpenseModel> box, _) {
            final expenses = box.values.toList().cast<ExpenseModel>();

            double totalExpense = 0;
            for (var expense in expenses) {
              totalExpense += expense.amount;
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 2000,
              slivers: [
                // PREMIUM APP BAR
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  snap: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 90,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text(
                      'Cash Nova',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                // PREMIUM HEADER CARD
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF4F46E5),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.30),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Balance',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            '₹${totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  'Transactions',
                                  expenses.length.toString(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _statCard(
                                  'This Month',
                                  '₹${totalExpense.toStringAsFixed(0)}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // SECTION TITLE
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Recent Expenses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),

                // EMPTY STATE
                if (expenses.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 90,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No expenses yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475467),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                // PREMIUM LIST
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final expense = expenses[index];

                        return Dismissible(
                          key: ValueKey(expense.key),
                          direction: DismissDirection.horizontal,

                          // LEFT BG
                          background: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEF4444),
                                  Color(0xFFDC2626),
                                ],
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // RIGHT BG
                          secondaryBackground: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEF4444),
                                  Color(0xFFDC2626),
                                ],
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),

                          onDismissed: (_) async {
                            await expense.delete();

                            PremiumSnackbar.show(
                              context,
                              message: 'Expense deleted',
                              icon: Icons.delete_rounded,
                              color: const Color(0xFFEA580C), // orange-red
                            );
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditExpenseScreen(expense: expense),
                                  ),
                                );

                                PremiumSnackbar.show(
                                  context,
                                  message: 'Expense updated successfully',
                                  icon: Icons.edit_rounded,
                                  color: const Color(0xFF0EA5E9), // cyan blue
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.92),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB)
                                          .withOpacity(0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // ICON
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFDBEAFE),
                                            Color(0xFFEDE9FE),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(
                                        getCategoryIcon(expense.category),
                                        color: const Color(0xFF2563EB),
                                        size: 30,
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // TEXT
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expense.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Color(0xFF0F172A),
                                              decoration: TextDecoration.none,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                  const Color(0xFFEEF2FF),
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  expense.category,
                                                  style: const TextStyle(
                                                    color: Color(0xFF4F46E5),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    decoration:
                                                    TextDecoration.none,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              Expanded(
                                                child: Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(expense.date),
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xFF64748B),
                                                    fontSize: 13,
                                                    decoration:
                                                    TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // AMOUNT
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '- ₹${expense.amount.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Color(0xFFEF4444),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.edit_rounded,
                                              size: 14,
                                              color: Color(0xFF64748B),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Tap to edit',
                                              style: TextStyle(
                                                color: Color(0xFF64748B),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: expenses.length,
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            );
          },
        ),
      ),

      // PREMIUM FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2563EB),
              Color(0xFF7C3AED),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: 'home_fab',
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddExpenseScreen(),
              ),
            );

            // ONLY TOP PREMIUM NOTIFICATION
            PremiumSnackbar.show(
              context,
              message: 'Expense added successfully',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF0EA5E9),
            );
          },
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Expense',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}