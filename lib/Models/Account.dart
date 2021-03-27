class Account {
  final String uid;

  final String email;
  final String password;
  final String displayName;

  final String photoUrl;

  final bool isPremium;

  /// Storage checks
  final int collectionCount;
  final int activitiesCount;

  final List<String> collectionsIDs;
  final List<String> activitiesIDs;

  Account({
    this.uid,
    this.email,
    this.password,
    this.displayName,
    this.photoUrl,
    this.isPremium = false,
    this.activitiesCount = 0,
    this.collectionCount = 0,
    this.collectionsIDs,
    this.activitiesIDs,
  });

  Account copyWith({
    String uid,
    String email,
    String password,
    String displayName,
    String photoUrl,
    bool isPremium,
    int activitiesCount,
    int collectionCount,
    List<String> collectionsIDs,
    List<String> activitiesIDs,
  }) {
    return Account(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      collectionCount: collectionCount ?? this.collectionCount,
      activitiesCount: activitiesCount ?? this.activitiesCount,
      collectionsIDs: collectionsIDs ?? this.collectionsIDs,
      activitiesIDs: activitiesIDs ?? this.activitiesIDs,
    );
  }

  Account.fromMap(Map account)
      : uid = account['uid'],
        email = account['email'],
        password = account['password'],
        displayName = account['displaydisplayName'],
        photoUrl = account['photoURL'],
        isPremium = account['isPremium'] ?? false,
        collectionCount = account['collectionCount'] ?? 0,
        activitiesCount = account['activitiesCount'] ?? 0,
        activitiesIDs = account['activitiesIDs'] ?? [],
        collectionsIDs = account['collectionsIDs'] ?? [];

  Map<String, dynamic> toMap() => {
        "uid": this.uid,
        "email": this.email,
        "password": this.password,
        "displayName": this.displayName,
        "isPremium": this.isPremium,
        "photoURL": this.photoUrl,
        "collectionCount": this.collectionCount,
        "activitiesCount": this.activitiesCount,
      };

  Map<String, dynamic> toMapFirestore() => {
        "isPremium": this.isPremium,
        "collectionCount": this.collectionCount,
        "activitiesCount": this.activitiesCount,
      };

  Map<String, dynamic> toMapFirestoreSubDocument() => {
        "activitiesIDs": this.activitiesIDs,
        "collectionsIDs": this.collectionsIDs,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
