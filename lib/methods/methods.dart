import 'dart:math';

import 'package:apod/const.dart';
import 'package:apod/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<Welcome> apod() async {
  final client = http.Client();
  final uri = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$API_KEY}');
  final response = await client.get(uri);
  if(response.statusCode == 200){
    return welcomeFromJson(response.body);
  }
  else{
    return Welcome(title: 'Error', copyright: 'Aman Jain', date: DateTime.tryParse('12/08/2003'), explanation: 'You got an error', url: 'https://i.imgur.com/dLfPsSw.png');
  }
}

Future<Welcome> dateApod(DateTime date) async {
  final y = '${date.year}';
  final m = '${date.month}';
  final d = '${date.day}';
  final client = http.Client();
  final uri = Uri.parse('https://api.nasa.gov/planetary/apod?date=$y-$m-$d&api_key=$API_KEY');
  final response = await client.get(uri);
  if(response.statusCode == 200){
    return welcomeFromJson(response.body);
  }
  else{
    return Welcome(title: 'Error', copyright: 'Aman Jain', date: DateTime.tryParse('12/08/2003'), explanation: 'You got an error', url: 'https://i.imgur.com/dLfPsSw.png');
  }
}

class HorizontalRotatingDots extends StatefulWidget {
  final double size;
  final Color color;

  const HorizontalRotatingDots({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  _HorizontalRotatingDotsState createState() => _HorizontalRotatingDotsState();
}

class _HorizontalRotatingDotsState extends State<HorizontalRotatingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _leftDotTranslate;

  late Animation<double> _middleDotScale;
  late Animation<Offset> _middleDotTranslate;

  late Animation<double> _rightDotScale;
  late Animation<Offset> _rightDotTranslate;

  final Interval _interval = const Interval(
    0.0,
    1.0,
    curve: Curves.easeOutCubic,
  );
  @override
  void initState() {
    super.initState();
    final double size = widget.size;
    final double dotSize = size / 4;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _leftDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(size - dotSize, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _middleDotScale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _middleDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-(size - dotSize) / 2, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _rightDotScale = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _rightDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-(size - dotSize) / 2, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final Color color = widget.color;
    final double dotSize = size / 4;
    final List<String> planets = [ 'mars',  'saturn', 'moon'];
    final planet = planets[Random().nextInt(planets.length)];
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Transform.translate(
              offset: _leftDotTranslate.value,
              child: DrawDot.circular(
                planet: planet,
                dotSize: dotSize,
                color: color,
              ),
            ),
            Transform.scale(
              scale: _middleDotScale.value,
              child: Transform.translate(
                offset: _middleDotTranslate.value,
                child: DrawDot.circular(
                  planet: planet,
                  dotSize: dotSize,
                  color: color,
                ),
              ),
            ),
            Transform.translate(
              offset: _rightDotTranslate.value,
              child: Transform.scale(
                scale: _rightDotScale.value,
                child: DrawDot.circular(
                  planet: planet,
                  dotSize: dotSize,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

