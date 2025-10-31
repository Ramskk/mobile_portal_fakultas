import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_informatika/pages/detail_berita_page.dart';
import 'package:portal_informatika/services/pengumuman_service.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final PengumumanService _service = PengumumanService();
  List<Map<String, String>> pengumumanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPengumuman();
  }

  Future<void> loadPengumuman() async {
    final data = await _service.fetchPengumuman();
    setState(() {
      pengumumanList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0C4C8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          'Pengumuman',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF0C4C8A)),
      )
          : RefreshIndicator(
        onRefresh: loadPengumuman,
        color: themeColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pengumumanList.length,
          itemBuilder: (context, index) {
            final item = pengumumanList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailBeritaPage(
                      title: item['title'] ?? '',
                      url: item['link'] ?? '',
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['date'] != null
                            ? item['date']!.substring(0, 10)
                            : '',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
