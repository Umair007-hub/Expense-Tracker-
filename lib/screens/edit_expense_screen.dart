import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';
import '../utils/premium_snackbar.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseModel expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;

  late String selectedCategory;
  late DateTime selectedDate;

  bool isSaving = false;

  final List<String> categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Medicine',
    'Education',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    // AUTO FILL EXISTING DATA
    titleController = TextEditingController(text: widget.expense.title);
    amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(0),
    );

    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              secondary: Color(0xFF7C3AED),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      PremiumSnackbar.show(
        context,
        message: 'Please enter valid details',
        icon: Icons.error_rounded,
        color: const Color(0xFFEF4444),
      );
      return;
    }

    setState(() => isSaving = true);

    // UPDATE EXISTING EXPENSE
    widget.expense.title = title;
    widget.expense.amount = amount;
    widget.expense.category = selectedCategory;
    widget.expense.date = selectedDate;

    await widget.expense.save();

    if (!mounted) return;

    PremiumSnackbar.show(
      context,
      message: 'Expense updated successfully',
      icon: Icons.check_circle_rounded,
    );

    Navigator.pop(context);
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
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PREMIUM APP BAR
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Expense',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Update your transaction details',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // FORM
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // GLASS FORM CARD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 30,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITLE FIELD
                            const Text(
                              'Expense Title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _premiumField(
                              controller: titleController,
                              hint: 'e.g. Dinner at restaurant',
                              icon: Icons.edit_rounded,
                            ),

                            const SizedBox(height: 24),

                            // AMOUNT FIELD
                            const Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _premiumField(
                              controller: amountController,
                              hint: '0',
                              icon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 24),

                            // CATEGORY
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEEF2FF),
                                    Color(0xFFF5F3FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFDBEAFE),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCategory,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF2563EB),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                  items: categories.map((category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedCategory = value);
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // DATE PICKER
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 12),

                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEEF2FF),
                                      Color(0xFFF5F3FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFDBEAFE),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2563EB),
                                            Color(0xFF7C3AED),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(Icons.calendar_month_rounded,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd MMMM yyyy')
                                            .format(selectedDate),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded,
                                        color: Color(0xFF64748B)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2563EB),
                                Color(0xFF4F46E5),
                                Color(0xFF7C3AED),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x332563EB),
                                blurRadius: 24,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isSaving ? null : _saveExpense,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_rounded, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _premiumField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEEF2FF),
            Color(0xFFF5F3FF),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            decoration: TextDecoration.none,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}