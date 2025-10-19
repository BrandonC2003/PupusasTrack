/// Small helpers to (de)serialize enums to strings for Firestore and JSON.
String enumToName(Object e) => e.toString().split('.').last;

T enumFromName<T>(List<T> values, String name, T fallback) {
  return values.firstWhere(
    (v) => v.toString().split('.').last == name,
    orElse: () => fallback,
  );
}
