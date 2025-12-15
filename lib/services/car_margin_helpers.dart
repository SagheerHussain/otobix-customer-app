class CarMarginHelpers {
  CarMarginHelpers._();

  static const double fixedMargin = 4.0;

  static double toLacs(num? priceDiscovery) {
    final n = (priceDiscovery ?? 0).toDouble();
    if (!n.isFinite || n <= 0) return 0;
    return n > 1000 ? n / 100000 : n;
  }

  static ({double fixed, double variable}) getMargins(num? priceDiscovery) {
    final lacs = toLacs(priceDiscovery);

    double variable = 0;
    if (lacs > 0 && lacs <= 1)
      variable = 16;
    else if (lacs <= 3)
      variable = 14;
    else if (lacs <= 5)
      variable = 12;
    else if (lacs <= 10)
      variable = 10;
    else if (lacs <= 25)
      variable = 8;
    else if (lacs > 0)
      variable = 6;

    return (fixed: fixedMargin, variable: variable);
  }

  static double getVariableMargin(num? priceDiscovery) {
    return getMargins(priceDiscovery).variable;
  }

  static double netAfterMargins({
    required num amount,
    required double fixedPercent,
    required double variablePercent,
  }) {
    final a = amount.toDouble();
    final totalPercent = fixedPercent + variablePercent;
    final deduction = a * (totalPercent / 100.0);
    return a - deduction;
  }

  /// Rounds to nearest 1000 (e.g., 12450 -> 12000, 12550 -> 13000)
  static int roundToNearest1000(num value) {
    return ((value.toDouble() / 1000).round() * 1000);
  }

  /// If [variableMargin] is null/0 => use PD slab; else use provided variableMargin.
  /// If [roundTo1000] is true => rounds final to nearest 1000.
  static double netAfterMarginsFlexible({
    required num originalPrice,
    required num? priceDiscovery,
    double? variableMargin,
    bool roundTo1000 = true,
  }) {
    final pdMargins = getMargins(priceDiscovery);
    final usedVariable = (variableMargin == null || variableMargin == 0)
        ? pdMargins.variable
        : variableMargin;

    final net = netAfterMargins(
      amount: originalPrice,
      fixedPercent: pdMargins.fixed,
      variablePercent: usedVariable,
    );

    return roundTo1000 ? roundToNearest1000(net).toDouble() : net;
  }
}
