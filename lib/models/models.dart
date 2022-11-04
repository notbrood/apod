import 'dart:convert';

import 'package:apod/methods/methods.dart';
import 'package:flutter/material.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.copyright,
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.serviceVersion,
    this.title,
    this.url,
  });

  String? copyright;
  DateTime? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        copyright: json["copyright"],
        date: DateTime.parse(json["date"]),
        explanation: json["explanation"],
        hdurl: json["hdurl"],
        mediaType: json["media_type"],
        serviceVersion: json["service_version"],
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "copyright": copyright,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "explanation": explanation,
        "hdurl": hdurl,
        "media_type": mediaType,
        "service_version": serviceVersion,
        "title": title,
        "url": url,
      };
}

Widget horizontalRotatingDots({
  required Color color,
  required double size,
  Key? key,
}) {
  return HorizontalRotatingDots(
    color: color,
    size: size,
    key: key,
  );
}

class DrawDot extends StatelessWidget {
  final double width;
  final double height;
  final bool circular;
  final Color color;
  final String planet;

  const DrawDot.circular({
    Key? key,
    required double dotSize,
    required this.color, required this.planet,
  })  : width = dotSize,
        height = dotSize,
        circular = true,
        super(key: key);

  const DrawDot.elliptical({
    Key? key,
    required this.width,
    required this.height,
    required this.color, required this.planet,
  })  : circular = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.white, blurRadius: 10)],
        image: DecorationImage(image: AssetImage('lib/images/$planet.png')),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular
            ? null
            : BorderRadius.all(Radius.elliptical(width, height)),
      ),
    );
  }
}


