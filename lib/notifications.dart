import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class sakit {
  final String penyakit;
  final String obat;

  sakit({required this.penyakit, required this.obat});

  factory sakit.fromJson(Map<String, dynamic> json) {
    return sakit(
      obat: json['obat'],
      penyakit: json['penyakit'],
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<sakit>> _sakitFuture;

  @override
  void initState() {
    super.initState();
    _fetchsakitAndSetState();
  }

  Future<void> _fetchsakitAndSetState() async {
    setState(() {
      _sakitFuture = fetchsakit();
    });
  }

  // Fungsi untuk mengambil data sakit dari API
  Future<List<sakit>> fetchsakit() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.8:3000/api/getsakit'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status']) {
        List<dynamic> data = responseData['data'];
        return data.map((item) => sakit.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load Obat data');
      }
    } else {
      throw Exception('Failed to load Obat data');
    }
  }

  void _deletesakit(String penyakit) {
    // Lakukan pembaruan data setelah menghapus sakit
    _performAfterDelete(() {
      setState(() {
        _sakitFuture = _sakitFuture.then((sakit) {
          return sakit.where((sakit) => sakit.penyakit != penyakit).toList();
        });
      });
    });
  }

  // Fungsi untuk melakukan sesuatu setelah menghapus sakit
  void _performAfterDelete(void Function() action) {
    // Misalnya, Anda bisa menampilkan pesan, atau melakukan sesuatu yang lain
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Penyakit'),
        backgroundColor: Color.fromARGB(255, 25, 104, 193),
        // Sesuaikan dengan tema aplikasi Anda
      ),
      body: FutureBuilder<List<sakit>>(
        future: _sakitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final sakit = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 38, 101,
                          217), // Sesuaikan dengan tema aplikasi Anda
                      child: Text(
                        sakit.obat[0].toUpperCase(),
                        style: TextStyle(
                          color: Color.fromARGB(185, 229, 193, 193),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      sakit.obat,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      sakit.penyakit,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deletesakit(sakit.penyakit);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
