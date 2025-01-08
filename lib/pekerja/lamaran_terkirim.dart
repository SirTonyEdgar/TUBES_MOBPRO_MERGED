import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar_pekerja.dart';

class LamaranTerkirim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Lamaran Kerja',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildJobApplicationsTitle(),
          const SizedBox(height: 8),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildJobApplicationTable(),
        ],
      ),
      bottomNavigationBar: BottomNavBarPekerja(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildJobApplicationsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            '1 Lamaran Pekerjaan',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4FD),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari jabatan pekerjaan atau nomor referensi',
                  border: InputBorder.none,
                ),
                style: GoogleFonts.poppins(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobApplicationTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: double.infinity,
          child: DataTable(
            columns: _buildTableColumns(),
            rows: _buildTableRows(),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            headingRowHeight: 40,
            columnSpacing: 24,
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(
        label: Text(
          'No',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Pekerjaan',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Status',
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ),
    ];
  }

  List<DataRow> _buildTableRows() {
    return [
      DataRow(
        cells: [
          DataCell(Text(
            '1',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
          )),
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kasir',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                'Jakarta Utara',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
              ),
            ],
          )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Diterima',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )),
        ],
      ),
    ];
  }
}
