class Mosque {
  final int mosId;
  final int tenantId;
  final int moduleId;
  final String mosName;
  final String address;
  final String tnName; // Assuming TnName is the mosque name
  final String moduleName;
  final String mosLogoUrl;

  Mosque({
    required this.mosId,
    required this.tenantId,
    required this.moduleId,
    required this.mosName,
    required this.address,
    required this.tnName,
    required this.moduleName,
    required this.mosLogoUrl
  });

  factory Mosque.fromJson(Map<String, dynamic> json) {
    return Mosque(
      mosId: json['MosId'] ?? 0, // Default to 0 if null
      tenantId: json['TenantId'] ?? 0, // Default to 0 if null
      moduleId: json['ModuleId'] ?? 0, // Default to 0 if null
      mosName: json['MosName'] ?? 'Unknown Mosque', // Default if null
      address: json['AddressLine1'] ?? 'No Address', // Default if null
      tnName: json['TnName'] ?? 'Unknown Mosque', // Default if null
      moduleName: json['ModuleName'] ?? '', // Default if null
      mosLogoUrl: json['mosLogoUrl'] ?? '',
    );
  }
}

