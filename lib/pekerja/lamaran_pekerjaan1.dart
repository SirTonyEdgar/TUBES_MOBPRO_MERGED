import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lamaran_pekerjaan2.dart';

class LamaranPekerjaan1 extends StatefulWidget {
  final String companyName;
  final int idPekerjaan;
  final String jobTitle;
  final String businessName;

  LamaranPekerjaan1({
    required this.companyName,
    required this.idPekerjaan,
    required this.jobTitle,
    required this.businessName,
  });

  @override
  _LamaranPekerjaan1State createState() => _LamaranPekerjaan1State();
}

class _LamaranPekerjaan1State extends State<LamaranPekerjaan1> {
  List<String> questions = [];
  final Map<int, String> answers = {}; // Perbaikan tipe data

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.18.5:3000/api/recommendedQuestions/${widget.idPekerjaan}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questions = List<String>.from(data['questions']);
        });
      } else {
        print('Failed to load questions: ${response.body}');
      }
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lamar Pekerjaan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tampilan Header
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.business, size: 30, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.jobTitle,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.businessName,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pertanyaan
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];

                        Widget questionWidget;

                        // Tentukan jenis input berdasarkan pertanyaan
                        if (question.contains("gaji bulanan")) {
                          questionWidget = TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan jumlah...',
                              prefixText: 'Rp. ',
                              prefixStyle: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.black),
                            ),
                          );
                        } else if (question.contains("tahun pengalaman")) {
                          // Pilihan dropdown untuk pengalaman
                          questionWidget = DropdownButtonFormField<String>(
                            items: [
                              '<1 Tahun',
                              '1-2 Tahun',
                              '3-4 Tahun',
                              '5+ Tahun',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value ?? '';
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Pilih pengalaman...',
                            ),
                          );
                        } else if (question.contains("Microsoft Office")) {
                          // Kotak centang untuk aplikasi Microsoft Office
                          List<String> options = [
                            'Word',
                            'Excel',
                            'PowerPoint',
                            'Teams'
                          ];
                          final List<String> selectedOptions = [];

                          questionWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: options.map((option) {
                              return CheckboxListTile(
                                title: Text(option),
                                value: selectedOptions.contains(option),
                                onChanged: (bool? selected) {
                                  setState(() {
                                    if (selected == true) {
                                      selectedOptions.add(option);
                                    } else {
                                      selectedOptions.remove(option);
                                    }
                                    answers[index] =
                                        jsonEncode(selectedOptions);
                                  });
                                },
                              );
                            }).toList(),
                          );
                        } else if (question
                            .contains("kemampuan bahasa Inggris")) {
                          // Pilihan radio untuk kemampuan bahasa Inggris
                          List<String> options = [
                            'Basic',
                            'Conversational',
                            'Fluent',
                            'Proficient'
                          ];
                          questionWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: options.map((option) {
                              return RadioListTile(
                                title: Text(option),
                                value: option,
                                groupValue: answers[index],
                                onChanged: (value) {
                                  setState(() {
                                    answers[index] = value ?? '';
                                  });
                                },
                              );
                            }).toList(),
                          );
                        } else if (question.contains("bersedia bepergian")) {
                          // Pilihan radio Ya/Tidak untuk bepergian
                          questionWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ['Ya', 'Tidak'].map((option) {
                              return RadioListTile(
                                title: Text(option),
                                value: option,
                                groupValue: answers[index],
                                onChanged: (value) {
                                  setState(() {
                                    answers[index] = value ?? '';
                                  });
                                },
                              );
                            }).toList(),
                          );
                        } else if (question.contains("Bahasa apa saja")) {
                          // TextField biasa dengan kemampuan menambahkan baris baru
                          questionWidget = TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan bahasa yang dikuasai...',
                            ),
                          );
                        } else if (question
                            .contains("latar belakang pekerja")) {
                          // Pilihan radio Ya/Tidak untuk pemeriksaan latar belakang
                          questionWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ['Ya', 'Tidak'].map((option) {
                              return RadioListTile(
                                title: Text(option),
                                value: option,
                                groupValue: answers[index],
                                onChanged: (value) {
                                  setState(() {
                                    answers[index] = value ?? '';
                                  });
                                },
                              );
                            }).toList(),
                          );
                        } else {
                          // Default ke TextField biasa
                          questionWidget = TextField(
                            onChanged: (value) {
                              setState(() {
                                answers[index] = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan jawaban Anda...',
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              questionWidget,
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Tombol "Berikutnya"
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LamaranPekerjaan2(
                              companyName: widget.companyName,
                              idPekerjaan: widget.idPekerjaan,
                              jobTitle: widget
                                  .jobTitle, // Gunakan data dari widget saat ini
                              businessName: widget
                                  .businessName, // Gunakan data dari widget saat ini
                              textAnswers: answers,
                              optionAnswers: {}, // Tetap kosong jika tidak ada opsi tambahan
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Berikutnya',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
