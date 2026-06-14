// lib/features/admin/screens/finans_view.dart
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/repositories/transaction_repository.dart';

class FinansView extends StatefulWidget {
  const FinansView({super.key});

  @override
  State<FinansView> createState() => _FinansViewState();
}

class _FinansViewState extends State<FinansView> {
  final TransactionRepository _repository = TransactionRepository();
  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  String selectedFilter = "Tüm Zamanlar";
  bool _isLoading = true;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _repository.fetchAllTransactions();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildHeader(),
          TabBar(
            indicatorColor: primaryRed,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white30,
            tabs: const [
              Tab(text: "KOMİSYON ÖDEMELERİ"),
              Tab(text: "CÜZDAN YÜKLEMELERİ")
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white30))
                : TabBarView(
              children: [
                _buildTransactionList('withdrawal'), // Kodundaki type ile uyumlu hale getirdim
                _buildTransactionList('deposit'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(String type) {
    var filteredData = _repository.filterTransactions(type: type, filterType: selectedFilter);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        var data = filteredData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6)),
          child: ListTile(
            onTap: () => _showDetailDialog(context, data),
            title: Text(data['description'] ?? "İşlem", style: const TextStyle(color: Colors.white, fontSize: 13)),
            trailing: Text("${data['amount'] ?? 0} TL", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text("İşlem Detayı", style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExpansionTile(
                title: Text("Filtre: $selectedFilter", style: const TextStyle(color: Colors.white30)),
                children: ["Günlük", "Haftalık", "Aylık", "3 Aylık", "6 Aylık", "1 Yıllık", "Tüm Zamanlar"]
                    .map((f) => ListTile(
                    title: Text(f, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() => selectedFilter = f);
                      Navigator.pop(context);
                    }
                )).toList(),
              ),
              const Divider(color: Colors.white10),
              ListTile(
                title: const Text("İşlemi Yapan Usta", style: TextStyle(color: Colors.white54, fontSize: 12)),
                subtitle: Text(data['userName'] ?? "Bilinmiyor", style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: const [
        Icon(Icons.account_balance_wallet, color: Colors.white38),
        SizedBox(width: 10),
        Text("FİNANSAL AKIŞ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ])
  );
}