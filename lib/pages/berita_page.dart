import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portal_informatika/pages/detail_berita_page.dart';
import 'package:portal_informatika/services/berita_service.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final BeritaService _beritaService = BeritaService();
  List<Map<String, String>> beritaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBerita();
  }

  Future<void> loadBerita() async {
    final data = await _beritaService.fetchBerita();
    setState(() {
      beritaList = data;
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
          'Berita Terbaru',
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
        onRefresh: loadBerita,
        color: themeColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: beritaList.length,
          itemBuilder: (context, index) {
            final berita = beritaList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailBeritaPage(
                      title: berita['title'] ?? '',
                      url: berita['link'] ?? '',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (berita['image'] != null &&
                        berita['image']!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          berita['image']!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            berita['title'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            berita['date'] != null
                                ? berita['date']!.substring(0, 10)
                                : '',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
