import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _penyakitController = TextEditingController();
  bool _isLoading = false;
  String? _jenissakit;
  String? _errorMessage;

  Future<void> _getsakit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _jenissakit = null;
    });

    final String penyakit = _penyakitController.text;
    final response = await http.get(
      Uri.parse('http://192.168.1.8:3000/api/getsakit/$penyakit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']) {
        final data = responseData['data'];
        setState(() {
          _jenissakit = data['obat'];
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data: ${responseData['message']}';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Nama Penyakit Tidak Ditemukan';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cek Obat'), backgroundColor: Colors.teal),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Selamat Datang, ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _penyakitController,
              decoration: InputDecoration(
                labelText: 'Nama Penyakit',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _getsakit,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.teal, // Ubah di sini
                    ),
                    child: Text('Cek'),
                  ),
            SizedBox(height: 20),
            _jenissakit != null
                ? Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Jenis Obat:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _jenissakit!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _errorMessage != null
                    ? Card(
                        color: Colors.red[100],
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Error:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
