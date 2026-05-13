import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('fr');
  Locale get locale => _locale;

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final code  = prefs.getString('locale') ?? 'fr';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> changer(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);
    _locale = Locale(code);
    notifyListeners();
  }
}