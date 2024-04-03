class UserA {
  final String displayName; // Made nullable if you intend instances without these details
  final String email; // Made nullable
  final String photoUrl; // Made nullable
  final String uid; // Made nullable or consider required if it's essential for every user
  bool? firstRun; // Remains nullable as it has a default setter

    UserA({
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.uid, // Making it required if every user must have a unique identifier
  });

  set updateFirstRun(bool value) => firstRun = value; // Setter for firstRun
}
