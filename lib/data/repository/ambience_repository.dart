import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbienceRepository {
  List<Ambience> _ambiences = [];

  Future<List<Ambience>> loadAmbiences() async {
    try {
      final String response = await rootBundle.loadString('assets/ambiences.json');
      final List<dynamic> data = json.decode(response);
      _ambiences = data.map((json) => Ambience.fromJson(json)).toList();
      return _ambiences;
    } catch (e) {
      throw Exception('Failed to load ambiences: $e');
    }
  }

  List<Ambience> getAmbiences() => _ambiences;

  Ambience? getAmbienceById(String id) {
    try {
      return _ambiences.firstWhere((ambience) => ambience.id == id);
    } catch (e) {
      return null;
    }
  }
}