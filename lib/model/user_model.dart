class User {
  String? username;
  String? email;
  String? phoneNo;
  String? imageUrl;

  User({this.username, this.email, this.phoneNo, this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['Uaname'] ?? 'Unknown User',
      email: json['Email'] ?? 'No Email',
      phoneNo: json['PhoneNo'] ?? 'No Phone',
      imageUrl: json['UaphotoUrl'] != null
          ? 'https://test.cmsbstaging.com.my${json['UaphotoUrl']}'
          : null,
    );
  }
}