class CatogerModel {
  final String id;
  final String name;
  final String sectionId;


  CatogerModel({
    required this.id,
    required this.name,
    required this.sectionId,
  });

  static CatogerModel? selected;
}
