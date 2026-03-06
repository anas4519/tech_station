import 'package:flutter/material.dart';

/// Maps common device color names to Flutter Color values.
/// Names are stored lowercase for case-insensitive matching.
const Map<String, Color> deviceColorMap = {
  // ── Blacks & Grays ──
  'midnight black': Color(0xFF1C1C1E),
  'phantom black': Color(0xFF1A1A2E),
  'obsidian': Color(0xFF1D1D1F),
  'graphite': Color(0xFF535353),
  'space gray': Color(0xFF8A8A8E),
  'space grey': Color(0xFF8A8A8E),
  'gray': Color(0xFF8E8E93),
  'grey': Color(0xFF8E8E93),
  'charcoal': Color(0xFF36454F),
  'onyx': Color(0xFF353839),

  // ── Whites & Silvers ──
  'white': Color(0xFFF5F5F7),
  'pearl white': Color(0xFFF0EAD6),
  'frost white': Color(0xFFEEF0F2),
  'silver': Color(0xFFC0C0C0),
  'starlight': Color(0xFFF0E6D3),
  'cream': Color(0xFFFFFDD0),

  // ── Blues ──
  'blue': Color(0xFF007AFF),
  'midnight blue': Color(0xFF191970),
  'pacific blue': Color(0xFF1D6FA5),
  'sierra blue': Color(0xFF9BB5CE),
  'alpine blue': Color(0xFF6BA3BE),
  'ultramarine': Color(0xFF3F00FF),
  'ocean blue': Color(0xFF4F97A3),
  'titanium blue': Color(0xFF394F6A),
  'ice blue': Color(0xFFA5D8DD),

  // ── Greens ──
  'green': Color(0xFF34C759),
  'midnight green': Color(0xFF004953),
  'alpine green': Color(0xFF485B4E),
  'sage': Color(0xFFB2AC88),
  'mint': Color(0xFF98FB98),
  'forest green': Color(0xFF228B22),

  // ── Reds & Pinks ──
  'red': Color(0xFFFF3B30),
  'product red': Color(0xFFBF0013),
  'coral': Color(0xFFFF6F61),
  'pink': Color(0xFFFF2D55),
  'rose gold': Color(0xFFB76E79),
  'lavender': Color(0xFFE6E6FA),
  'lilac': Color(0xFFC8A2C8),

  // ── Purples ──
  'purple': Color(0xFFAF52DE),
  'deep purple': Color(0xFF5E35B1),
  'violet': Color(0xFF7F00FF),

  // ── Yellows & Oranges ──
  'yellow': Color(0xFFFFCC00),
  'gold': Color(0xFFFFD700),
  'amber': Color(0xFFFFBF00),
  'orange': Color(0xFFFF9500),
  'peach': Color(0xFFFFDAB9),
  'sunset gold': Color(0xFFE8A317),

  // ── Titanium / Premium ──
  'natural titanium': Color(0xFF8F8A81),
  'titanium': Color(0xFF878681),
  'titanium gray': Color(0xFF76766E),
  'titanium desert': Color(0xFFBFB5A3),
  'titanium black': Color(0xFF3A3A3C),
  'titanium white': Color(0xFFE3DFD6),

  // ── Bronze / Copper ──
  'bronze': Color(0xFFCD7F32),
  'copper': Color(0xFFB87333),

  // ── Special ──
  'phantom': Color(0xFF2E2E38),
  'burgundy': Color(0xFF800020),
  'mystic bronze': Color(0xFFC4956A),
  'cloud navy': Color(0xFF2C3E50),
  'bubblegum': Color(0xFFFFC1CC),
};

/// Find the best matching color for a device color name.
/// Returns grey if no match is found.
Color getDeviceColor(String colorName) {
  final lower = colorName.toLowerCase().trim();

  // Exact match
  if (deviceColorMap.containsKey(lower)) {
    return deviceColorMap[lower]!;
  }

  // Partial match — find the first key that's contained in the input or vice versa
  for (final entry in deviceColorMap.entries) {
    if (lower.contains(entry.key) || entry.key.contains(lower)) {
      return entry.value;
    }
  }

  // Keyword fallback — check if any core color word is present
  final keywords = {
    'black': const Color(0xFF1C1C1E),
    'white': const Color(0xFFF5F5F7),
    'blue': const Color(0xFF007AFF),
    'green': const Color(0xFF34C759),
    'red': const Color(0xFFFF3B30),
    'pink': const Color(0xFFFF2D55),
    'purple': const Color(0xFFAF52DE),
    'yellow': const Color(0xFFFFCC00),
    'gold': const Color(0xFFFFD700),
    'orange': const Color(0xFFFF9500),
    'silver': const Color(0xFFC0C0C0),
    'gray': const Color(0xFF8E8E93),
    'grey': const Color(0xFF8E8E93),
    'titanium': const Color(0xFF878681),
    'bronze': const Color(0xFFCD7F32),
    'copper': const Color(0xFFB87333),
  };

  for (final entry in keywords.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  return const Color(0xFF8E8E93); // default grey
}

/// Get all color names sorted alphabetically (for admin picker).
List<String> get allDeviceColorNames {
  final names = deviceColorMap.keys.toList();
  names.sort();
  return names;
}
