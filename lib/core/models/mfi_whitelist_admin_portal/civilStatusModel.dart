class CivilStatusData {
  late int id;
  late String title;

  CivilStatusData({required this.id, required this.title});

  factory CivilStatusData.fromJson(Map<String, dynamic> json) {
    return CivilStatusData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

List<CivilStatusData> titles = titleList.map((json) => CivilStatusData.fromJson(json)).toList();
const titleList = [
  {'id': 1, 'title': 'Single'},
  {'id': 2, 'title': 'Married'},
  {'id': 3, 'title': 'Widowed'},
  {'id': 4, 'title': 'Separated'},
  // {'id': 5, 'title': 'Divorced'},
  {'id': 6, 'title': 'Common-Law/Live-In'},
];
