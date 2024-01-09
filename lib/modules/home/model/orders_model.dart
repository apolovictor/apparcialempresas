class DashboardOrders {
  final int orderDocument;
  final String? documentId;
  final int? openingClose;
  final int status;

  DashboardOrders(
    this.orderDocument,
    this.documentId,
    this.openingClose,
    this.status,
  );

  static DashboardOrders fromDoc(dynamic doc) {
    return DashboardOrders(
      doc!['orderDocument'],
      doc['idDocument'],
      doc['openingClose'],
      doc['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderDocument': orderDocument,
      'idDocument': documentId,
      'openingClose': openingClose,
      'status': status,
    };
  }
}
