import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // debugPrint için bunu ekledik
import 'expense_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; 

  // --- 1. GİRİŞ YAP ---
  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token-al/'),
        body: {'username': username, 'password': password},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body)['token'];
      }
    } catch (e) {
      // UYARI ÇÖZÜMÜ: print() yerine debugPrint() kullanıyoruz.
      // Bu sayede uygulama markete yüklendiğinde bu loglar gizlenecek.
      debugPrint("Login Hatası: $e"); 
    }
    return null;
  }

  // --- 2. HARCAMALARI GETİR (READ) ---
  Future<List<Expense>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/harcamalar/'),
      headers: {'Authorization': 'Token $token'},
    );
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => Expense.fromJson(data)).toList();
    } else {
      throw Exception('Harcamalar yüklenemedi.');
    }
  }

  // --- 3. HARCAMA EKLE (CREATE) ---
  Future<bool> addExpense(String token, String title, String amount, String category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/harcamalar/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'amount': amount, 'category': category}),
    );
    return response.statusCode == 201; // 201 Created
  }

  // --- 4. HARCAMA GÜNCELLE (UPDATE) ---
  Future<bool> updateExpense(String token, int id, String title, String amount, String category) async {
    final response = await http.put(
      Uri.parse('$baseUrl/harcamalar/$id/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'amount': amount, 'category': category}),
    );
    return response.statusCode == 200; // 200 OK
  }

  // --- 5. HARCAMA SİL (DELETE) ---
  Future<bool> deleteExpense(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/harcamalar/$id/'),
      headers: {'Authorization': 'Token $token'},
    );
    return response.statusCode == 204; // 204 No Content
  }
}