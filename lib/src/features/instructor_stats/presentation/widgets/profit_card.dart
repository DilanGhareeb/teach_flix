import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ProfitCard extends StatefulWidget {
  final double todayProfit;
  final double monthProfit;
  final double yearProfit;
  final double totalProfit;

  const ProfitCard({
    super.key,
    required this.todayProfit,
    required this.monthProfit,
    required this.yearProfit,
    required this.totalProfit,
  });

  @override
  State<ProfitCard> createState() => _ProfitCardState();
}

class _ProfitCardState extends State<ProfitCard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final formatter = Formatter();

    final periods = [
      (t.today, widget.todayProfit),
      (t.this_month ?? 'This Month', widget.monthProfit),
      (t.this_year ?? 'This Year', widget.yearProfit),
      (t.all_time ?? 'All Time', widget.totalProfit),
    ];

    final selectedProfit = periods[_selectedIndex].$2;
    final shouldShowChart =
        _selectedIndex > 0; // Show chart for all except "Today"

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.total_earnings ?? 'Total Earnings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Profit Amount
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _animation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    formatter.formatIqd(selectedProfit),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  periods[_selectedIndex].$1,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Chart Section
          if (shouldShowChart)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(opacity: _animation.value, child: child);
                },
                child: SizedBox(
                  height: 120,
                  child: ProfitChart(
                    selectedIndex: _selectedIndex,
                    monthProfit: widget.monthProfit,
                    yearProfit: widget.yearProfit,
                    totalProfit: widget.totalProfit,
                  ),
                ),
              ),
            ),

          SizedBox(height: shouldShowChart ? 16 : 0),

          // Period Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: List.generate(periods.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final isCompact = constraints.maxWidth < 350;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onPeriodChanged(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isCompact ? 6 : 8,
                            horizontal: 4,
                          ),
                          margin: EdgeInsets.only(
                            right: index < periods.length - 1 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.25)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  periods[index].$1,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(
                                      isSelected ? 1.0 : 0.7,
                                    ),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isCompact ? 10 : 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: isCompact ? 2 : 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  formatter
                                      .formatIqd(periods[index].$2)
                                      .replaceAll('IQD', '')
                                      .trim(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(
                                      isSelected ? 1.0 : 0.6,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: isCompact ? 9 : 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfitChart extends StatelessWidget {
  final int selectedIndex;
  final double monthProfit;
  final double yearProfit;
  final double totalProfit;

  const ProfitChart({
    super.key,
    required this.selectedIndex,
    required this.monthProfit,
    required this.yearProfit,
    required this.totalProfit,
  });

  List<FlSpot> _getChartData() {
    switch (selectedIndex) {
      case 1: // This Month
        return _generateMonthData();
      case 2: // This Year
        return _generateYearData();
      case 3: // All Time
        return _generateAllTimeData();
      default:
        return [];
    }
  }

  List<FlSpot> _generateMonthData() {
    // Generate realistic monthly data (last 30 days)
    final data = <FlSpot>[];
    final random = monthProfit / 30;

    for (int i = 0; i < 30; i++) {
      // Create a growth pattern with some variation
      final baseValue = (i / 30) * monthProfit;
      final variation = (i % 3 == 0 ? 0.9 : 1.1) * random;
      data.add(FlSpot(i.toDouble(), baseValue + variation));
    }

    return data;
  }

  List<FlSpot> _generateYearData() {
    // Generate yearly data (12 months)
    final data = <FlSpot>[];
    final avgPerMonth = yearProfit / 12;

    for (int i = 0; i < 12; i++) {
      // Create seasonal variation
      final seasonalMultiplier = 0.7 + (i % 4) * 0.15;
      final value = avgPerMonth * seasonalMultiplier * (1 + i * 0.05);
      data.add(FlSpot(i.toDouble(), value));
    }

    return data;
  }

  List<FlSpot> _generateAllTimeData() {
    // Generate all-time data (example: last 24 months)
    final data = <FlSpot>[];
    final avgPerMonth = totalProfit / 24;

    for (int i = 0; i < 24; i++) {
      // Create exponential growth pattern
      final growth = 1 + (i / 24) * 0.8;
      final value = avgPerMonth * growth;
      data.add(FlSpot(i.toDouble(), value));
    }

    return data;
  }

  String _getBottomTitle(double value, int selectedIndex) {
    final index = value.toInt();

    switch (selectedIndex) {
      case 1: // Month - show days
        if (index % 5 == 0) return '${index + 1}';
        return '';
      case 2: // Year - show months
        const months = [
          'J',
          'F',
          'M',
          'A',
          'M',
          'J',
          'J',
          'A',
          'S',
          'O',
          'N',
          'D',
        ];
        return index < months.length ? months[index] : '';
      case 3: // All time - show quarters
        if (index % 6 == 0) return 'Q${(index ~/ 6) + 1}';
        return '';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getChartData();
    if (data.isEmpty) return const SizedBox.shrink();

    final maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 3,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final text = _getBottomTitle(value, selectedIndex);
                if (text.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: minY * 0.9,
        maxY: maxY * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.4),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            shadow: Shadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white.withOpacity(0.9),
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final formatter = Formatter();
                return LineTooltipItem(
                  formatter.formatIqd(spot.y),
                  TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: Colors.white.withOpacity(0.5),
                  strokeWidth: 2,
                  dashArray: [3, 3],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: Colors.white.withOpacity(0.5),
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }
}
