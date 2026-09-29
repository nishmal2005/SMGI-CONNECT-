import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),

              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFFF5A623),
                    size: w * 0.07,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _HelpSupportTile(
                      icon: Icons.chat,
                      iconColor: Colors.white,
                      iconBg: const Color(0xFF25D366),
                      label: 'WhatsApp Support',
                      onTap: () {},
                    ),
                    const _DottedDivider(),
                    _HelpSupportTile(
                      icon: Icons.call,
                      iconColor: const Color(0xFF3B6FE0),
                      iconBg: Colors.transparent,
                      label: 'Call Support',
                      onTap: () {},
                    ),
                    const _DottedDivider(),
                    _HelpSupportTile(
                      icon: Icons.email,
                      iconColor: const Color(0xFFE0642A),
                      iconBg: Colors.transparent,
                      label: 'Email Support',
                      onTap: () {},
                    ),
                    const _DottedDivider(),
                    _HelpSupportTile(
                      icon: Icons.help,
                      iconColor: Colors.white,
                      iconBg: const Color(0xFFB0B4BB),
                      label: 'FAQ',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpSupportTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const _HelpSupportTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.045,
          vertical: w * 0.035,
        ),
        child: Row(
          children: [
            iconBg == Colors.transparent
                ? Icon(icon, color: iconColor, size: w * 0.06)
                : CircleAvatar(
                    radius: w * 0.032,
                    backgroundColor: iconBg,
                    child: Icon(icon, color: iconColor, size: w * 0.04),
                  ),
            SizedBox(width: w * 0.035),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: w * 0.038,
                  color: const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF9AA0A6),
              size: w * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.045),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 5.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Flex(
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                ),
              );
            }).map((dash) => Padding(
                  padding: const EdgeInsets.only(right: dashSpace),
                  child: dash,
                )).toList(),
          );
        },
      ),
    );
  }
}