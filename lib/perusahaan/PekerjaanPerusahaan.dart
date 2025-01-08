import 'package:flutter/material.dart';

class PekerjaanPage extends StatefulWidget {
  @override
  _PekerjaanPageState createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: "Buka"),
            Tab(text: "Kadaluwarsa"),
            Tab(text: "Kandidat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TabBuka(),
          Center(child: Text("Halaman Kadaluwarsa (dalam pengembangan)")),
          TabKandidat(),
        ],
      ),
    );
  }
}

class TabBuka extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari jabatan pekerjaan atau nomor referensi",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("No")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Pekerjaan")),
                      DataColumn(label: Text("Kandidat")),
                      DataColumn(label: Text("Kinerja")),
                      DataColumn(label: Text("Tindakan")),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text("1")),
                        DataCell(Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Aktif",
                            style: TextStyle(color: Colors.green),
                          ),
                        )),
                        DataCell(Text("Staff Administrasi\nJakarta Utara")),
                        DataCell(Text("1")),
                        DataCell(Text("78")),
                        DataCell(Text("-")),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TabKandidat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari berdasarkan nama, jabatan, email",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            SizedBox(height: 16),

            // Tabel Kandidat
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("Nama")),
                  DataColumn(label: Text("Posisi Terbaru")),
                  DataColumn(label: Text("Status")),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text("1")),
                    DataCell(Text("John Morgan",
                        style: TextStyle(color: Colors.blue))),
                    DataCell(Text("Staff Administrasi")),
                    DataCell(Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Menunggu Konfirmasi",
                        style: TextStyle(color: Colors.green),
                      ),
                    )),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
