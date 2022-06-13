class RegisterUser {
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final String fechaNacimiento;
  final int dni;
  final String email;
  RegisterUser(this.nombre, this.apellidoP, this.apellidoM, this.fechaNacimiento, this.dni, this.email);

  RegisterUser.fromMap(Map<String, dynamic> item) :
        nombre = item['nombre'],
        apellidoP = item['apellidoP'],
        apellidoM = item['apellidoM'],
        fechaNacimiento = item['fechaNacimiento'],
        dni = item['dni'],
        email = item['email'];

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellidoP': apellidoP,
      'apellidoM': apellidoM,
      'fechaNacimiento': fechaNacimiento,
      'dni': dni,
      'email': email
    };
  }
}