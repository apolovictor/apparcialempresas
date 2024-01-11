class DashboardTables {
  final int idTable;
  final String? documentId;
  final int? openingClose;
  final int status;
  // String documentId;
  DashboardTables(
    this.idTable,
    this.documentId,
    this.openingClose,
    this.status,
  );

  static DashboardTables fromDoc(dynamic doc) {
    return DashboardTables(
      doc!['idTable'],
      doc['idDocument'],
      doc['openingClose'],
      doc['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTable': idTable,
      'idDocument': documentId,
      'openingClose': openingClose,
      'status': status,
    };
  }
}
