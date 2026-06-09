class DoaModel {
  final String nama;
  final String doa;
  final String latin;
  final String artinya;

  DoaModel({
    required this.nama,
    required this.doa,
    required this.latin,
    required this.artinya,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      nama: (json['nama'] ?? '').toString(),
      doa: (json['doa'] ?? '').toString(),
      latin: (json['latin'] ?? '').toString(),
      artinya: (json['artinya'] ?? '').toString(),
    );
  }
}
