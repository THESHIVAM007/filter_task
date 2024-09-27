import 'dart:convert';
import 'package:filter_task/lead.dart';
import 'package:http/http.dart' as http;

Future<List<Lead>> fetchLeads(token) async {
  final response = await http.get(
    Uri.parse('https://crm-backend-1-hov9.onrender.com/lead/all'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> leadData = data['data'];

    return leadData.map((json) => Lead.fromJson(json)).toList();
  } else {
    throw Exception('could not get the data');
  }
}


Future<List<Lead>> filterLeads(token,query) async {
  final response = await http.get(
    Uri.parse('https://crm-backend-1-hov9.onrender.com/lead/search?$query'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> leadData = json.decode(response.body);

    return leadData.map((json) => Lead.fromJson(json)).toList();
  } else {
    throw Exception('could not get the data');
  }
}
