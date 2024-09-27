class Lead {
  final String? lastName;        
  final String? leadOwner;       
  final String? phoneNumber;     
  final String? email;           
  final String? state;           
  final DateTime? createdAt;     

  Lead({
    this.lastName,
    this.leadOwner,
    this.phoneNumber,
    this.email,
    this.state,
    this.createdAt,
  });

  // Factory constructor to create Lead from JSON
  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      lastName: json["lastName"] as String?,
      leadOwner: json["leadOwner"] as String?,
      phoneNumber: json["contact"] as String?,
      email: json["email"] as String?,
      state: json["State"] as String?,
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    );
  }
}
