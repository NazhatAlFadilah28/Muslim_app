class AsmaulHusnaModel {
  final int nomor;
  final String latin;
  final String arab;
  final String artinya;

  AsmaulHusnaModel({
    required this.nomor,
    required this.latin,
    required this.arab,
    required this.artinya,
  });

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      nomor: json['nomor'] ?? 0,
      latin: json['latin'] ?? '',
      arab: json['arab'] ?? '',
      artinya: json['artinya'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nomor': nomor, 'latin': latin, 'arab': arab, 'artinya': artinya};
  }
}
