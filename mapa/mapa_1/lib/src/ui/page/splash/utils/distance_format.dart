String distanceFormat(int valueInMeters) {
  if (valueInMeters >= 1000) {
    return '${(valueInMeters / 100).toStringAsFixed(1)}\nkm';
  }
  return '$valueInMeters\nm';
}
