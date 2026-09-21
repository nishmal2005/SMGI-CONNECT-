import 'package:flutter/material.dart';
//import 'package:smgi.connect/core/constants/app_colors.dart';
//import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/model/payment_model.dart';
import 'package:smgi.connect/shared/widgets/app_bar.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'payment_card.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  TextEditingController searchController = TextEditingController();

  // 📌 Static Demo Data
  List<PaymentModel> payments = [
    PaymentModel(
      title: "SMGI Finance",
      dateTime: "Feb 21, 2023 at 03:05 pm",
      amount: "₹5,000",
      status: "Success",
    ),
    PaymentModel(
      title: "State Bank",
      dateTime: "Jan 11, 2023 at 01:30 pm",
      amount: "₹3,200",
      status: "Failed",
    ),
    PaymentModel(
      title: "Axis Bank",
      dateTime: "Jan 10, 2023 at 11:10 am",
      amount: "₹1,000",
      status: "Pending",
    ),
    PaymentModel(
      title: "SMGI Finance",
      dateTime: "Dec 31, 2022 at 04:25 pm",
      amount: "₹7,500",
      status: "Success",
    ),
  ];

  List<PaymentModel> filteredPayments = [];

  @override
  void initState() {
    super.initState();
    filteredPayments = payments;
  }

  // 🔍 Search functionality
  void _filterSearch(String value) {
    setState(() {
      filteredPayments = payments.where((item) {
        final input = value.toLowerCase();
        return item.title.toLowerCase().contains(input) ||
            item.status.toLowerCase().contains(input) ||
            item.amount.toLowerCase().contains(input);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          const HomeAppBar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // 🔍 Search Field
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE4E4E4), width: 0.75),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterSearch,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📘 Payment List
                  Expanded(
                    child: filteredPayments.isEmpty
                        ? const Center(child: Text("No results found"))
                        : SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: List.generate(
                                  filteredPayments.length,
                                  (index) {
                                    final item = filteredPayments[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          child: PaymentCardWidget(
                                            title: item.title,
                                            dateTime: item.dateTime,
                                            amount: item.amount,
                                            status: item.status,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
