import 'package:flutter/material.dart';

import '../../../app/widgets/animated_counter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final int totalExpenses;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5B5FEF),
            Color(0xFF7A5AF8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B5FEF).withValues(alpha: .35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "Total Balance",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
            child: AnimatedCounter(
              value: totalBalance,
              prefix: "₱",
              decimals: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            )
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Expenses",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Text(
                "$totalExpenses recorded",
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}