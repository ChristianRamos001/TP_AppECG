class Doctor {
  final int idMedico;
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final int dni;
  final String urlIcon;
  Doctor(this.idMedico, this.nombre, this.apellidoP, this.apellidoM, this.dni, this.urlIcon);

  Doctor.fromMap(Map<String, dynamic> item) :
        idMedico = item['idMedico'],
        nombre = item['nombre'],
        apellidoP = item['apellidoP'],
        apellidoM = item['apellidoM'],
        dni = item['dni'],
        urlIcon = item['urlIcon'];

  Map<String, dynamic> toMap() {
    return {
      'idMedico': idMedico,
      'nombre': nombre,
      'apellidoP': apellidoP,
      'apellidoM': apellidoM,
      'dni': dni,
      'urlIcon': urlIcon
    };
  }
}