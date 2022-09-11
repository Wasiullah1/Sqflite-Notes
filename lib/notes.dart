class NotesModel {
  final int? id;
  final String name;
  final String email;
  final String gender;

  NotesModel(
      {this.id, required this.name, required this.email, required this.gender});

  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        email = res['email'],
        gender = res['gender'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
    };
  }
}
