import 'package:flutter/material.dart';
import 'package:habit_quest/config/config.dart';

class MyHabitsSection extends StatelessWidget {
  const MyHabitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const HeaderSummary(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Habit ${index + 1}'),
                subtitle: Text('Description ${index + 1}'),
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HeaderSummary extends StatelessWidget {
  const HeaderSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  '20',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  '13',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'PAUSED',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  '7',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
