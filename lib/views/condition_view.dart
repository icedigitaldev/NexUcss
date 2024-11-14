import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ConditionView extends StatelessWidget {
  final bool showBackButton;

  const ConditionView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: SafeArea(
            child: AppBar(
              automaticallyImplyLeading: showBackButton,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: showBackButton
                  ? GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEef1F4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF545F71),
                      size: 20,
                    ),
                  ),
                ),
              )
                  : null,
              title: Text(
                'Términos y Condiciones',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff545f70),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      'Términos y Condiciones del Aplicativo de Control de Docentes',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const HtmlWidget(
                      ''' 
                        <div style="font-family: poppins; line-height: 30px;">
                          <p style="font-size: 16px; font-weight: 500; ">Última actualización: 2-10-2024</p>
                          <p style="font-size: 16px; font-weight: 400;text-align: justify;">Estos Términos y Condiciones regulan el uso del aplicativo de control de docentes (en adelante, el "Aplicativo") desarrollado para la Universidad Católica Sedes Sapientiae (en adelante, la "Universidad"). Al acceder o utilizar el Aplicativo, aceptas cumplir y estar sujeto a estos Términos y Condiciones. Si no aceptas estos términos, no debes utilizar el Aplicativo.</p>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">1. Objeto del Aplicativo</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;">El Aplicativo tiene como finalidad gestionar y controlar la asistencia de los docentes en la Universidad Católica Sedes Sapientiae, permitiendo al personal autorizado el registro, monitoreo y gestión de los horarios y asistencia de los docentes.</p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">2. Usuarios Autorizados</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >El acceso y uso del Aplicativo está estrictamente limitado al personal responsable del monitoreo de horarios y asistencias designado por la Universidad. No se permitirá el acceso a otros usuarios ni a docentes.</p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">3. Recopilación de Información</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              El Aplicativo recopila datos relacionados únicamente con la asistencia de los docentes, los cuales no serán cargados a ninguna base de datos externa. Todos los datos se almacenarán localmente en el dispositivo del usuario autorizado. No se realizarán copias ni transferencias a servidores externos, garantizando que la información permanezca exclusivamente en el dispositivo del usuario.
                              </br>
                              Los datos incluyen:
                              <ul style="font-size: 16px; font-weight: 400;text-align: justify;">
                                <li>Nombres completos del docente</li><li>Registro de entrada, monitoreo y salida</li>
                                <li>Horarios asignados</li><li>Nombres completos de los responsables del monitoreo</li><li>Nombre completos y Datos de contacto de los coordinadores de cada carrera</li>
                              </ul>
                              <p style="font-size: 16px; font-weight: 400;text-align: justify;">El personal autorizado es responsable de asegurar la precisión de los datos ingresados y el correcto uso de la plataforma. Además queda estrictamente prohibido que los usuarios compartan, distribuyan o transfieran estos datos a terceros. El incumplimiento de esta política será motivo de sanciones por parte de la Universidad Católica Sedes Sapientiae.</p>
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">4. Responsabilidades del Personal Autorizado</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              Los usuarios aceptan:
                              <ul style="font-size: 16px; font-weight: 400;text-align: justify;">
                                <li>Utilizar el Aplicativo exclusivamente para el monitoreo de horarios y asistencia de los docentes.</li>
                                <li>No compartir sus credenciales de acceso (usuario y contraseña) con ninguna otra persona.</li>
                                <li>Reportar cualquier incidente de seguridad o uso indebido del Aplicativo.</li>
                                <li>Mantener la confidencialidad de los datos del personal docente monitoreado</li>
                              </ul>
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">5. Propiedad Intelectual</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              El Aplicativo, incluyendo su diseño y código, es propiedad exclusiva de los desarrolladores José Jarlin Chiquin, Jhordy Mondragón y William Calderón. Todos los derechos sobre el software y su estructura técnica están reservados a ellos.
                              </br>Por otro lado, el contenido ingresado al Aplicativo por el personal autorizado, así como los reportes generados, serán propiedad de la Universidad Católica Sedes Sapientiae. Sin embargo, estos datos no serán almacenados en ninguna base de datos externa y permanecerán localmente en el dispositivo del usuario autorizado. La distribución o el uso no autorizado de esta información está prohibido.
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">6. Limitaciones de Uso</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              El uso del Aplicativo se limita exclusivamente al personal autorizado para realizar el monitoreo de horarios y asistencia de los docentes.
                              </br>Queda prohibido utilizar el Aplicativo para cualquier otro propósito ajeno a su función principal.
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">7. Modificaciones a los Términos y Condiciones</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              Cualquier modificación a los términos relacionados con la recopilación, almacenamiento y manejo de datos del Aplicativo podrá ser realizada únicamente por los desarrolladores José Jarlin Chiquin, Jhordy Mondragón y William Calderón. La Universidad Católica Sedes Sapientiae podrá proponer cambios o ajustes a estos términos, pero dichos cambios estarán sujetos a una evaluación y aprobación previa por parte de los desarrolladores.</br>
                              Cualquier actualización será notificada a los usuarios autorizados, y el uso continuo del Aplicativo después de las modificaciones implicará la aceptación de los nuevos términos.
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">8. Exclusión de Responsabilidad</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              Los desarrolladores José Jarlin Chiquin, Jhordy Mondragón y William Calderón no garantizan que el Aplicativo funcione de manera ininterrumpida o libre de errores. El Aplicativo se proporciona "tal cual", sin garantías explícitas o implícitas de su funcionamiento o adecuación para un propósito específico.</br>
                              Los desarrolladores no serán responsables por ningún tipo de daño, directo o indirecto, que pueda derivarse del uso o la imposibilidad de usar el Aplicativo, incluyendo, pero no limitado a, pérdida de datos, interrupciones del servicio, problemas técnicos o cualquier otro perjuicio que pudiera afectar a los usuarios o a la Universidad Católica Sedes Sapientiae.</br>
                              El uso del Aplicativo es bajo la propia responsabilidad del usuario, y cualquier incidencia deberá ser reportada para su revisión y corrección, sin que ello implique responsabilidad legal para los desarrolladores.
                            </p>
                          </div>
                          <div>
                            <h2 style="font-weight: 700; font-size: 20px;">9. Contacto</h2>
                            <p style="font-size: 16px; font-weight: 400;text-align: justify;" >
                              Para cualquier duda, consulta o incidencia relacionada con el funcionamiento del Aplicativo, el personal autorizado de la Universidad deberá ponerse en contacto exclusivamente con los desarrolladores a través de los siguientes correos electrónicos:
                              <ul style="font-size: 16px; font-weight: 400;">
                                <li>iCe-Digital: sopport@icedigital.pe</li>
                                <li>William Calderón: william@email.com</li>
                              </ul>
                              <p style="font-family: Poppins; font-size: 16px; font-weight: 400;text-align: justify;">
                                El equipo de administración de la Universidad Católica Sedes Sapientiae podrá contactar a los desarrolladores para proponer cambios o resolver dudas técnicas relacionadas con el uso del Aplicativo. Cualquier comunicación relacionada con el manejo de datos o ajustes en el sistema deberá pasar por los desarrolladores para su evaluación y aprobación.
                              </p>
                            </p>
                          </div>
                        </div>
                       ''',
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xff9aa5b6), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Aceptar',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xff545f70),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
