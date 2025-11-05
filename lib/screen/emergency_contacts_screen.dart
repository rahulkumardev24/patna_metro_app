import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<Map<String, dynamic>> contacts = [
    {
      'title': 'Patna Metro Helpline',
      'subtitle': 'For any metro-related emergency',
      'number': '155370',
      'icon': Icons.train,
      'color': Colors.redAccent,
    },
    {
      'title': 'Security Helpline',
      'subtitle': 'Report suspicious activity or theft',
      'number': '100',
      'icon': Icons.security,
      'color': Colors.deepOrange,
    },
    {
      'title': 'Fire Department',
      'subtitle': 'In case of fire or smoke',
      'number': '101',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
    {
      'title': 'Ambulance',
      'subtitle': 'For medical emergencies',
      'number': '102',
      'icon': Icons.local_hospital,
      'color': Colors.green,
    },
    {
      'title': 'Women Helpline',
      'subtitle': 'Safety support for women passengers',
      'number': '1091',
      'icon': Icons.woman,
      'color': Colors.pink,
    },
    {
      'title': 'Lost & Found',
      'subtitle': 'Help for lost belongings',
      'number': '1800-345-6888',
      'icon': Icons.search,
      'color': Colors.blue,
    },
  ];

  Future<void> _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $number')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: appTextStyle16(
            fontColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: contact['color'].withOpacity(0.2),
                child: Icon(contact['icon'], color: contact['color'], size: 26),
              ),
              title: Text(
                contact['title'],
                style: appTextStyle16(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(contact['subtitle']),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.teal),
                onPressed: () => _callNumber(contact['number']),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.red.shade50,
        child: Text(
          '⚠️ In case of emergency, contact the nearest metro staff or use station intercom.',
          textAlign: TextAlign.center,
          style: appTextStyle14(
            fontColor: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
