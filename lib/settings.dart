import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _obatController = TextEditingController();
  final TextEditingController _penyakitController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addsakit() async {
    setState(() {
      _isLoading = true;
    });

    final String Obat = _obatController.text;
    final String Penyakit = _penyakitController.text;

    final response = await http.post(
      Uri.parse('http://192.168.1.8:3000/api/addsakit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'obat': Obat,
        'penyakit': Penyakit,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']) {
        // Jika berhasil, tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Obat berhasil ditambahkan')),
        );
        _obatController.clear();
        _penyakitController.clear();
      } else {
        _showErrorDialog('Gagal menambah data: ${responseData['message']}');
      }
    } else {
      _showErrorDialog('Server error. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Obat'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Color.fromARGB(210, 16, 194, 16)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _obatController,
                      decoration: InputDecoration(
                        labelText: 'Nama Obat',
                        prefixIcon: Icon(Icons.medication_liquid_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _penyakitController,
                      decoration: InputDecoration(
                        labelText: 'Jenis Penyakit',
                        prefixIcon: Icon(Icons.post_add),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addsakit,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.teal, // Ubah di sini
                    ),
                    child: Text('Tambah Obat'),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}
