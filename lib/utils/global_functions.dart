import 'dart:convert';

import 'package:intl/intl.dart';

class GlobalFunctions {
  // Parse dynamic value to specific type
  static T? parse<T>(dynamic value) {
    if (value == null) return null;

    // int
    if (T == int) {
      if (value is int) return value as T;
      if (value is double) return value.toInt() as T;
      if (value is String) return int.tryParse(value) as T?;
    }

    // double
    if (T == double) {
      if (value is double) return value as T;
      if (value is int) return value.toDouble() as T;
      if (value is String) return double.tryParse(value) as T?;
    }

    // String
    if (T == String) {
      return value.toString() as T;
    }

    // DateTime
    if (T == DateTime) {
      if (value is DateTime) return value as T;
      if (value is String) return DateTime.tryParse(value) as T?;
    }

    // bool
    if (T == bool) {
      if (value is bool) return value as T;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true' || lower == '1') return true as T;
        if (lower == 'false' || lower == '0') return false as T;
      }
      if (value is int) return (value == 1) as T;
    }

    // List
    if (T == List) {
      if (value is List) return value as T;
    }

    // Map
    if (T == Map) {
      if (value is Map) return value as T;
    }

    // Fallback
    try {
      return value as T;
    } catch (_) {
      return null;
    }
  }

  // Parse lists
  static List<T> parseList<T>({
    required Type parsedListType,
    required List<dynamic> incomingList,
  }) {
    if (parsedListType == String) {
      return incomingList.map((e) => e.toString() as T).toList();
    }
    if (parsedListType == int) {
      return incomingList.map((e) => int.tryParse(e.toString()) as T).toList();
    }
    if (parsedListType == double) {
      return incomingList
          .map((e) => double.tryParse(e.toString()) as T)
          .toList();
    }
    throw UnsupportedError('Unsupported type: $parsedListType');
  }

  // Parse Date to a specific Format
  static const String year = 'year';
  static const String month = 'month';
  static const String monthName = 'monthname';
  static const String day = 'day';
  static const String weekday = 'weekday';
  static const String time = 'time';
  static const String dateTime = 'datetime';
  static const String clearDateTime = 'cleardatetime';
  static const String fullDate = 'fulldate';
  static const String date = 'date';
  static const String monthYear = 'monthyear';
  static const String dayMonth = 'daymonth';

  static String? getFormattedDate({
    required DateTime? date,
    required String type,
    bool treatAsIndiaLocal = true,
  }) {
    if (date == null) return null;

    // For India-only business dates
    final DateTime indiaDate = treatAsIndiaLocal
        ? date.toUtc().add(const Duration(hours: 5, minutes: 30))
        : date.toLocal();

    switch (type.toLowerCase()) {
      case year:
        return DateFormat('yyyy').format(indiaDate);
      case month:
        return DateFormat('MM').format(indiaDate);
      case monthName:
        return DateFormat('MMMM').format(indiaDate);
      case day:
        return DateFormat('dd').format(indiaDate);
      case weekday:
        return DateFormat('EEEE').format(indiaDate);
      case time:
        return DateFormat('hh:mm a').format(indiaDate);
      case dateTime:
        return DateFormat('dd-MM-yyyy hh:mm a').format(indiaDate);
      case clearDateTime:
        return DateFormat('dd MMM yyyy hh:mm a').format(indiaDate);
      case fullDate:
        return DateFormat('dd-MM-yyyy').format(indiaDate);
      case monthYear:
        return DateFormat('MM-yyyy').format(indiaDate);
      case dayMonth:
        return DateFormat('dd-MM').format(indiaDate);
      default:
        return DateFormat('dd-MM-yyyy').format(indiaDate); // fallback
    }
  }

  // =====================================================
  // 💰 Round & format amount to nearest 1000
  // =====================================================
  static T? roundToNearestThousand<T>(dynamic value) {
    if (value == null) return null;

    // Convert to number
    final num? numValue = (value is num)
        ? value
        : num.tryParse(value.toString());
    if (numValue == null) return null;

    // Round to nearest 1000
    final rounded = ((numValue / 1000).round()) * 1000;

    // Return in requested type
    if (T == int) return rounded.toInt() as T;
    if (T == double) return rounded.toDouble() as T;

    // Fallback
    return rounded as T;
  }

  // =====================================================
  // 📝 Print API Response in Prety Json
  // =====================================================
  static void printApiResponse({
    required dynamic input,
    String title = 'API INSPECT',
    bool unwrapData = false,
    bool printTypes = false,
    int chunkSize = 800,
  }) {
    try {
      dynamic obj = input;

      // If input is JSON string => decode
      if (obj is String) {
        final s = obj.trim();
        if ((s.startsWith('{') && s.endsWith('}')) ||
            (s.startsWith('[') && s.endsWith(']'))) {
          obj = jsonDecode(s);
        }
      }

      // Optionally unwrap json['data']
      if (unwrapData && obj is Map && obj.containsKey('data')) {
        obj = obj['data'];
      }

      // Pretty JSON
      String pretty;
      try {
        pretty = const JsonEncoder.withIndent('  ').convert(obj);
      } catch (_) {
        pretty = obj?.toString() ?? 'null';
      }

      // Chunked printing (prevents truncation)
      void logLong(String text) {
        if (text.isEmpty) {
          // ignore: avoid_print
          print('');
          return;
        }
        for (int i = 0; i < text.length; i += chunkSize) {
          final end = (i + chunkSize < text.length)
              ? i + chunkSize
              : text.length;
          // ignore: avoid_print
          print(text.substring(i, end));
        }
      }

      logLong('===== $title =====');
      logLong(pretty);
      logLong('===== END $title =====');

      // Print key -> type to find Null/String issues
      if (printTypes) {
        if (obj is Map) {
          logLong('--- $title (Key Types) ---');
          obj.forEach((k, v) {
            // ignore: avoid_print
            print('$k => ${v.runtimeType} | $v');
          });
        } else if (obj is List) {
          logLong('--- $title (List Info) ---');
          // ignore: avoid_print
          print('List length: ${obj.length}');
          if (obj.isNotEmpty) {
            // ignore: avoid_print
            print('First item type: ${obj.first.runtimeType}');
          }
        }
      }
    } catch (e, st) {
      // ignore: avoid_print
      print('❌ $title FAILED: $e');
      // ignore: avoid_print
      print('StackTrace: $st');
    }
  }

  // =====================================================
  // 📝 Parse MongoDB Date
  // =====================================================
  static DateTime? parseMongoDbDate(dynamic v) {
    try {
      if (v == null) return null;

      // 1) ISO string: "2025-08-11T10:50:00.000Z" or "+00:00" or no offset
      if (v is String) {
        // numeric string? treat as epoch ms
        final maybeNum = int.tryParse(v);
        if (maybeNum != null) {
          return DateTime.fromMillisecondsSinceEpoch(
            maybeNum,
            isUtc: true,
          ).toLocal();
        }

        final dt = DateTime.parse(
          v,
        ); // Dart sets isUtc=true if Z or +/-offset present
        return dt.isUtc ? dt.toLocal() : dt; // normalize to local
      }

      // 2) Epoch milliseconds (int)
      if (v is int) {
        return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true).toLocal();
      }

      // 3) Extended JSON: {"$date": "..."} or {"$date": 1723363800000} or {"$date":{"$numberLong":"..."}}
      if (v is Map) {
        final raw = v[r'$date'];
        if (raw == null) return null;

        if (raw is String) {
          // could be ISO or numeric string
          final maybeNum = int.tryParse(raw);
          if (maybeNum != null) {
            return DateTime.fromMillisecondsSinceEpoch(
              maybeNum,
              isUtc: true,
            ).toLocal();
          }
          final dt = DateTime.parse(raw);
          return dt.isUtc ? dt.toLocal() : dt;
        }

        if (raw is int) {
          return DateTime.fromMillisecondsSinceEpoch(
            raw,
            isUtc: true,
          ).toLocal();
        }

        if (raw is Map && raw[r'$numberLong'] != null) {
          final ms = int.tryParse(raw[r'$numberLong'].toString());
          if (ms != null) {
            return DateTime.fromMillisecondsSinceEpoch(
              ms,
              isUtc: true,
            ).toLocal();
          }
        }
      }
    } catch (e) {
      // optional: debugPrint('parseMongoDbDate error: $e  (value: $v)');
    }
    return null;
  }
}
