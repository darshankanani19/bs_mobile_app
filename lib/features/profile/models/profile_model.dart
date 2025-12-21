class ProfileModel {
  final String salonName;
  final String ownerName;
  final String imageUrl;

  ProfileModel({
    required this.salonName,
    required this.ownerName,
    required this.imageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      salonName: json['salon_name'],
      ownerName: json['owner_name'],
      imageUrl: json['image_url'],
    );
  }
}
