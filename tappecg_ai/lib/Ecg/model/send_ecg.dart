class SendECG {
  String user;
  List<int> listDataECG;
  DateTime readDate;

  SendECG(this.user, this.listDataECG, this.readDate);

  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'readDate': readDate.toIso8601String(),
        'listDataECG': listDataECG
      };
}
