import 'package:flutter/material.dart';

/// Global function to format view counts in a readable format
/// - 1000+ views: "X.Xk" format (e.g., "72.3k")
/// - 1000000+ views: "X.XXm" format (e.g., "1.23m")
/// - Less than 1000: original number as string
String formatViewCount(int viewCount) {
  if (viewCount >= 1000000) {
    return '${(viewCount / 1000000).toStringAsFixed(2)}M';
  } else if (viewCount >= 1000) {
    return '${(viewCount / 1000).toStringAsFixed(1)}K';
  } else {
    return viewCount.toString();
  }
}
