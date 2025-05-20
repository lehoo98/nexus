import 'package:flutter/material.dart';

Widget buildStarDisplay(double averageRating, {double size = 18}) {
  int fullStars = averageRating.floor();
  double remainder = (averageRating - fullStars);

  // Runden auf 0.25 Schritte
  double rounded = (remainder * 4).round() / 4;

  List<Widget> stars = [];

  // Volle Sterne
  for (int i = 0; i < fullStars; i++) {
    stars.add(Icon(Icons.star, color: Colors.amber, size: size));
  }

  // Teil-Stern je nach Viertel
  if (rounded == 0.25) {
    stars.add(Icon(Icons.star_border, color: Colors.amber, size: size)); // später ersetzen durch eigenes Icon
  } else if (rounded == 0.5) {
    stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
  } else if (rounded == 0.75) {
    stars.add(Icon(Icons.star, color: Colors.amber.shade200, size: size)); // heller als voll
  }

  // Rest auffüllen bis 5
  while (stars.length < 5) {
    stars.add(Icon(Icons.star_border, color: Colors.grey.shade400, size: size));
  }

  return Row(children: stars);
}
