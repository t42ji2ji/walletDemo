import 'dart:math' as math;

///Format Value
num formatToTRX(num? value) {
  if (value == null) return 0;
  return value / math.pow(10, 6);
}

num formatToSUN(num? value) {
  if (value == null) return 0;
  return value * math.pow(10, 6);
}

BigInt ethToWeiBi(num? value) {
  if (value == null) return BigInt.zero;
  return BigInt.from(value * math.pow(10, 18));
}
