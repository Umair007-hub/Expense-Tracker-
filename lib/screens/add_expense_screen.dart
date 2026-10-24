import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/expense_model.dart';
import '../utils/premium_snackbar.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Medicine',
    'Education',
    'Other',
  ];

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final box = Hive.box<ExpenseModel>('expenses');

    final expense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      date: _selectedDate,
      notes: _notesController.text.trim(),
    );

    await box.add(expense);

    if (!mounted) return;

    // ✅ ONLY PREMIUM TOP NOTIFICATION
    PremiumSnackbar.show(
      context,
      message: 'Expense added successfully',
      icon: Icons.check_circle_rounded,
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
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
                            'Add Expense',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create a new transaction',
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
                  child: Form(
                    key: _formKey,
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
                              // TITLE
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
                                controller: _titleController,
                                hint: 'e.g. Dinner at restaurant',
                                icon: Icons.edit_rounded,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Title is required';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              // AMOUNT
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
                                controller: _amountController,
                                hint: '0',
                                icon: Icons.currency_rupee_rounded,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Amount is required';
                                  }
                                  final amount =
                                  double.tryParse(value);
                                  if (amount == null || amount <= 0) {
                                    return 'Enter a valid amount';
                                  }
                                  return null;
                                },
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEEF2FF),
                                      Color(0xFFF5F3FF),
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFDBEAFE),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF2563EB),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration:
                                      TextDecoration.none,
                                    ),
                                    items: _categories.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // DATE
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
                                    borderRadius:
                                    BorderRadius.circular(22),
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
                                          gradient:
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFF2563EB),
                                              Color(0xFF7C3AED),
                                            ],
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        child: const Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w600,
                                            decoration:
                                            TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // NOTES
                              const Text(
                                'Notes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEEF2FF),
                                      Color(0xFFF5F3FF),
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFDBEAFE),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _notesController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    decoration:
                                    TextDecoration.none,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Optional notes...',
                                    hintStyle: TextStyle(
                                      decoration:
                                      TextDecoration.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.note_rounded,
                                      color: Color(0xFF2563EB),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder:
                                    InputBorder.none,
                                    focusedBorder:
                                    InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.all(20),
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
                              borderRadius:
                              BorderRadius.circular(22),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x332563EB),
                                  blurRadius: 24,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed:
                              _isSaving ? null : _saveExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.transparent,
                                shadowColor:
                                Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(22),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save_rounded,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Save Expense',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.bold,
                                      decoration:
                                      TextDecoration.none,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PREMIUM FIELD WIDGET
  Widget _premiumField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
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
          contentPadding:
          const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}