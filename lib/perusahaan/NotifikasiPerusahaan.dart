import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifikasi"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: "Semua"),
            Tab(text: "Kandidat"),
            Tab(text: "Lowongan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Semua notifikasi
          NotifikasiList(notifications: allNotifications),
          // Notifikasi kategori "Kandidat"
          NotifikasiList(
              notifications: allNotifications
                  .where((n) => n.category == "Kandidat")
                  .toList()),
          // Notifikasi kategori "Lowongan"
          NotifikasiList(
              notifications: allNotifications
                  .where((n) => n.category == "Lowongan")
                  .toList()),
        ],
      ),
    );
  }
}

// Data Model untuk Notifikasi
class NotificationItem {
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String imageUrl;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.imageUrl,
  });
}

// Data Dummy Notifikasi
List<NotificationItem> allNotifications = [
  NotificationItem(
    title: "Staff Administrasi",
    subtitle: "John Morgan telah melamar Pekerjaan.",
    category: "Kandidat",
    date: "17 Desember",
    imageUrl: "assets/default_logo.png",
  ),
  NotificationItem(
    title: "Data Analyst",
    subtitle: "Lowongan Anda akan berakhir dalam 2 hari.",
    category: "Lowongan",
    date: "20 Desember",
    imageUrl: "assets/default_logo.png",
  ),
];

// Widget untuk Daftar Notifikasi
class NotifikasiList extends StatelessWidget {
  final List<NotificationItem> notifications;

  NotifikasiList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                Image.asset(
                  notification.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                // Detail Notifikasi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Judul Notifikasi
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          // Chip Kategori
                          Chip(
                            label: Text(
                              notification.category,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: notification.category == "Kandidat"
                                ? Colors.blue
                                : Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(notification.subtitle),
                      SizedBox(height: 4),
                      Text(
                        notification.date,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
