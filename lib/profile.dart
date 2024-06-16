import 'package:flutter/material.dart';

enum Role { Admin, Service, Keamanan, Mekanik }

class Profile {
  final String name;
  final String devisi;
  final String email;
  final String bio;
  final String photo;
  final Map<String, String> statistics;
  final List<Map<String, String>> recentActivities;

  Profile({
    required this.name,
    required this.devisi,
    required this.email,
    required this.bio,
    required this.photo,
    required this.statistics,
    required this.recentActivities,
  });
}

class ProfilePage extends StatelessWidget {
  final profiles = [
    Profile(
      name: 'Rizqi Mubarrok',
      devisi: 'Admin',
      email: 'admin@example.com',
      bio: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      photo: 'assets/barok.jpg',
      statistics: {'Posting': '100', 'Pengikut': '102', 'Mengikuti': '201'},
      recentActivities: [],
    ),
    Profile(
      name: "Roni Ardiansyah",
      devisi: 'Service',
      email: 'service@example.com',
      bio: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.',
      photo: 'assets/roni.jpg',
      statistics: {'Posting': '50', 'Pengikut': '1208', 'Mengikuti': '100'},
      recentActivities: [],
    ),
    Profile(
      name: "Gusmantuh Dwi Cahyono",
      devisi: 'Petugas apk',
      email: 'apoteker_attendant@example.com',
      bio: 'At vero eos et accusamus et iusto odio dignissimos ducimus.',
      photo: 'assets/foto1.jpg',
      statistics: {'Obat apk': '1980', 'obat Terdaftar': '23'},
      recentActivities: [],
    ),
    Profile(
      name: "Wella Vernanda Meilasaroh",
      devisi: 'Petugas apk',
      email: 'apoteker_attendant@example.com',
      bio: 'At vero eos et accusamus et iusto odio dignissimos ducimus.',
      photo: 'assets/wella.jpg',
      statistics: {'Obat apk': '402', 'Obat Terdaftar': '307'},
      recentActivities: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 37, 75, 199),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: profiles.map((profile) {
            return ProfileWidget(profile: profile);
          }).toList(),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final Profile profile;

  const ProfileWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(205, 59, 119, 210),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(profile.photo),
          ),
          SizedBox(height: 20),
          Text(
            profile.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profile.devisi,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profile.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: profile.statistics.entries.map((entry) {
              return _buildStatistic(title: entry.key, value: entry.value);
            }).toList(),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Text(
            'Bio:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            profile.bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Tambahkan fungsi untuk mengedit profil
            },
            child: Text('Edit Profil'),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Text(
            'Aktivitas Terbaru:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: profile.recentActivities.map((activity) {
              return _buildRecentActivity(
                activity: activity['activity']!,
                timestamp: activity['timestamp']!,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
      {required String activity, required String timestamp}) {
    return ListTile(
      title: Text(activity),
      subtitle: Text(timestamp),
      leading: Icon(Icons.history),
    );
  }
}
