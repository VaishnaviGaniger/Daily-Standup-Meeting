class ProjectListModel {
  final String name;
  final String description;
  // final int lead;
  final int id;

  ProjectListModel({
    required this.name,
    required this.description,
    // required this.lead,
    required this.id,
  });

  factory ProjectListModel.fromJson(Map<String, dynamic> json) {
    return ProjectListModel(
      name: json['name'],
      description: json['description'],
      // lead: json['lead'],
      id: json['id'],
    );
  }
}
