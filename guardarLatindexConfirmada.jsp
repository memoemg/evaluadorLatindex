<%-- 
    Document   : guardarLatindexConfirmada
    Created on : 10/08/2020, 01:35:00 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.basicosConfirmados"%>
<%@page import="ucrindex.gestionConfirmados"%>
<%@page import="ucrindex.enLineaConfirmados"%>
<%@page import="ucrindex.contenidoConfirmados"%>
<%@page import="ucrindex.presentacionConfirmados"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"  %>
<%@page import="java.sql.*"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="java.util.Properties"%>

<% Class.forName("com.mysql.jdbc.Driver");

    double notaLatindex = (Double.parseDouble(request.getParameter("notaLatindex")));
    String indexada = request.getParameter("indexada");
    String fechaProxEva = request.getParameter("proximaEva");

%>

<%!
    public class conexionBD {

        private Connection conn;  //Objeto Connection
        private String url;  //URL al servidor donde se encuenta la BD
        private String dbName;   //Nombre de la base de datos
        private String driver;	 //Driver utilizado para establecer la conexión
        private String userName;   //Usuario con privilegios en la BD
        private String password;   //Contraseña del usuario

        public conexionBD() {
            /*Datos conexión a XAMPP en compu de Memo*/
            conn = null;
            url = "jdbc:mysql://127.0.0.1:3306/";
            dbName = "eva2020";
            driver = "com.mysql.jdbc.Driver";
            userName = "latindex";
            password = "w4k4w4k4";
        }

//Método encargado de establecer la conexión con la BD, no recibe parámetros ni retorna.
        public void abrirConexion() {
            try {
                Class.forName(driver).newInstance();
                conn = DriverManager.getConnection(url + dbName, userName, password);  //Método mágico que conecta con la BD
                //System.out.println("Connected to the database");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        //Método encargado de cerrar la conexión, no recibe parámetros ni retorna.
        public void cerrarConexion() {
            try {
                conn.close();
                //System.out.println("Disconnected from database");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        //Método para consultar a la Base de Datos, recibe el String con la consulta SQL y retorna un objeto ResultSet
        //con la(s) tupla(s) resultante
        public ResultSet consultaSQL(String sentencia) {

            //Inicialización de variables locales necesarias
            Statement st = null;
            ResultSet rs = null;

            try {
                st = conn.createStatement();  //Se instancia un objeto Statement
                rs = st.executeQuery(sentencia);  //Y se ejecuta la consulta, almacenando la respuesta en un ResultSet
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            return rs;
        }

        //Método utilizado para realizar operaciones sobre la BD, recibe el String con la operación SQL y retorna
        //un entero que indica si hubo éxito o no
        public int operacionSQL(String sentencia) {

            //Inicialización de variables locales necesarias
            Statement st = null;
            int rs = -1;

            try {
                st = conn.createStatement();  //Se instancia un objeto Statement
                rs = st.executeUpdate(sentencia);  //Se ejecuta la operación sobre la BD
            } catch (SQLException ex) {
                ex.printStackTrace();

            }

            return rs;
        }

        //Método utilizado para ingresar una revista a la base de datos, recibe un objeto revista y retorna un entero
        //El entero retornado corresponde al que devuelve operacionSQL
        public int actualizarDatosRevista(String issn, String fasciculo, String fechaConfirmacion, String proximaEvaluacion, int estado) {
            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `datosrevista` SET `fasciculo` = '" + fasciculo + "', `fechaConfirmacion` = '" + fechaConfirmacion + "', `fechaProxEva` = '" + proximaEvaluacion + "', `estado`= " + estado + " WHERE `datosrevista`.issn = '" + issn + "';";

            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmaBasicos(String issnRevista, String responsables, String generacionContinua,
                String identificacionAutores, String entidadEditora, String instruccionesAutores, String sistemaArbitraje,
                String issnCriterio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmabasicos`(`issnRevista`, `responsables`, `generacionContinua`, `identificacionAutores`, `entidadEditora`, `instruccionesAutores`, `sistemaArbitraje`, `issnCriterio`) VALUES ('" + issnRevista + "', '" + responsables + "', '" + generacionContinua + "', '" + identificacionAutores + "', '" + entidadEditora + "', '" + instruccionesAutores + "', '" + sistemaArbitraje + "', '" + issnCriterio + "');";
            //System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmaGestion(String issnRevista, String definicionRevista, int autoresExternos, int autoresInternos, int miembrosInternos, int miembrosExternos, String serviciosInformacion, String cumplimientoPeriodicidad, String politicaAccesoReuso, String codigoEtica, String deteccionPlagio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmagestion`(`issnRevista`, `definicionRevista`, `autoresExternos`, `autoresInternos`, `miembrosInternos`, `miembrosExternos`, `serviciosInformacion`, `cumplimientoPeriodicidad`, `politicaAccesoReuso`, `codigoEtica`, `deteccionPlagio`) VALUES ('" + issnRevista + "', '" + definicionRevista + "', " + autoresExternos + ", " + autoresInternos + ", " + miembrosInternos + ", " + miembrosExternos + ", '" + serviciosInformacion + "', '" + cumplimientoPeriodicidad + "', '" + politicaAccesoReuso + "', '" + codigoEtica + "', '" + deteccionPlagio + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmaEnLinea(String issnRevista, String interoperabilidad, boolean formatosEdicion, String valorAgregado, String interactividad, String buscadores, boolean identificadoresDeRecurso, String estadisticas, String politicaPreservacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmaenlinea`(`issnRevista`, `interoperabilidad`, `formatosEdicion`, `valorAgregado`, `interactividad`, `buscadores`, `identificadoresDeRecurso`, `estadisticas`, `politicaPreservacion`) VALUES ('" + issnRevista + "', '" + interoperabilidad + "', " + formatosEdicion + ", '" + valorAgregado + "', '" + interactividad + "', '" + buscadores + "', " + identificadoresDeRecurso + ", '" + estadisticas + "', '" + politicaPreservacion + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmaContenido(String issnRevista, int documentosOriginales, int otrosTipos, String referenciasBibliograficas, String exigenciaOriginalidad, boolean resumen, boolean resumenDosIdiomas, boolean palabras, boolean palabrasDosIdiomas, int cantidadArticulosAnho) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmacontenido`(`issnRevista`, `documentosOriginales`, `otrosTipos`, `referenciasBibliograficas`, `exigenciaOriginalidad`, `resumen`, `resumenDosIdiomas`, `palabras`, `palabrasDosIdiomas`, `cantidadArticulosAnho`) VALUES ('" + issnRevista + "', " + documentosOriginales + ", " + otrosTipos + ", '" + referenciasBibliograficas + "', '" + exigenciaOriginalidad + "', " + resumen + ", " + resumenDosIdiomas + ", " + palabras + ", " + palabrasDosIdiomas + ", " + cantidadArticulosAnho + ");";
            System.out.println("estoy en insertarConfirmaContenido");
            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmaPresentacion(String issnRevista, boolean navegacion, boolean accesoHistorico, String mencionPeriodicidad, boolean membreteInicio, String afiliacionCuerposEditoriales, boolean afiliacionAutores, boolean fechasRecepcionAceptacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmapresentacion`(`issnRevista`, `navegacion`, `accesoHistorico`, `mencionPeriodicidad`, `membreteInicio`, `afiliacionCuerposEditoriales`, `afiliacionAutores`, `fechasRecepcionAceptacion`) VALUES ('" + issnRevista + "', " + navegacion + ", " + accesoHistorico + ", '" + mencionPeriodicidad + "', " + membreteInicio + ", '" + afiliacionCuerposEditoriales + "', " + afiliacionAutores + ", " + fechasRecepcionAceptacion + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int actualizarNotaLatindex(String issnRevista, double notaLatindex) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `notas` SET `notaLatindex` = " + notaLatindex + " WHERE issnRevista = '" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int actualizarEstadoIndexada(String issnRevista, boolean indexada) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `notas` SET `indexada` = " + indexada + " WHERE issnRevista = '" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesConfirmacion(String issnRevista, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11, String observacion12, String observacion13, String observacion14, String observacion15,
                String observacion16, String observacion17, String observacion18, String observacion19, String observacion20, String observacion21, String observacion22, String observacion23, String observacion24, String observacion25, String observacion26, String observacion27, String observacion28, String observacion29, String observacion30, String observacion31, String observacion32, String observacion33,
                String observacion34, String observacion35, String observacion36, String observacion37, String observacion38) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionesconfirmalatindex`(`issnrevista`, `observacionConfirma1`, `observacionConfirma2`, `observacionConfirma3`, `observacionConfirma4`, `observacionConfirma5`, `observacionConfirma6`, `observacionConfirma7`, `observacionConfirma8`, `observacionConfirma9`, `observacionConfirma10`, `observacionConfirma11`,"
                    + " `observacionConfirma12`, `observacionConfirma13`, `observacionConfirma14`, `observacionConfirma15`, `observacionConfirma16`, `observacionConfirma17`, `observacionConfirma18`, `observacionConfirma19`, `observacionConfirma20`, `observacionConfirma21`, `observacionConfirma22`, `observacionConfirma23`, `observacionConfirma24`, `observacionConfirma25`, `observacionConfirma26`, `observacionConfirma27`, `observacionConfirma28`,"
                    + " `observacionConfirma29`, `observacionConfirma30`, `observacionConfirma31`, `observacionConfirma32`, `observacionConfirma33`, `observacionConfirma34`, `observacionConfirma35`, `observacionConfirma36`, `observacionConfirma37`, `observacionConfirma38`) VALUES ('" + issnRevista + "', '" + observacion1 + "', '" + observacion2 + "', '" + observacion3 + "', '" + observacion4 + "', '" + observacion5 + "', '" + observacion6 + "', '" + observacion7 + "', '" + observacion8 + "', '" + observacion9 + "', '" + observacion10
                    + "', '" + observacion11 + "', '" + observacion12 + "', '" + observacion13 + "', '" + observacion14 + "', '" + observacion15 + "', '" + observacion16 + "', '" + observacion17 + "', '" + observacion18 + "', '" + observacion19 + "', '" + observacion20 + "', '" + observacion21 + "', '" + observacion22 + "', '" + observacion23 + "', '" + observacion24 + "', '" + observacion25 + "', '" + observacion26 + "', '" + observacion27 + "', '" + observacion28 + "', '" + observacion29 + "', '" + observacion30 + "', '" + observacion31 + "', '" + observacion32 + "', '" + observacion33
                    + "', '" + observacion34 + "', '" + observacion35 + "', '" + observacion36 + "', '" + observacion37 + "', '" + observacion38 + "');";

            System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int actualizarObservacionesEvaluacion(String issnRevista, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11, String observacion12, String observacion13, String observacion14, String observacion15,
                String observacion16, String observacion17, String observacion18, String observacion19, String observacion20, String observacion21, String observacion22, String observacion23, String observacion24, String observacion25, String observacion26, String observacion27, String observacion28, String observacion29, String observacion30, String observacion31, String observacion32, String observacion33,
                String observacion34, String observacion35, String observacion36, String observacion37, String observacion38) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `observacionesevalatindex` SET `observacionEva1`='" + observacion1 + "', `observacionEva2`='" + observacion2 + "', `observacionEva3`='" + observacion3 + "', `observacionEva4`='" + observacion4 + "', `observacionEva5`='" + observacion5 + "', `observacionEva6`='" + observacion6 + "', `observacionEva7`='" + observacion7 + "', `observacionEva8`='" + observacion8 + "', `observacionEva9`='" + observacion9 + "', `observacionEva10`='" + observacion10 + "', `observacionEva11`='" + observacion11 + "',"
                    + " `observacionEva12`='" + observacion12 + "', `observacionEva13`='" + observacion13 + "', `observacionEva14`='" + observacion14 + "', `observacionEva15`='" + observacion15 + "', `observacionEva16`='" + observacion16 + "', `observacionEva17`='" + observacion17 + "', `observacionEva18`='" + observacion18 + "', `observacionEva19`='" + observacion19 + "', `observacionEva20`='" + observacion20 + "', `observacionEva21`='" + observacion21 + "', `observacionEva22`='" + observacion22 + "', `observacionEva23`='" + observacion23 + "', `observacionEva24`='" + observacion24 + "', `observacionEva25`='" + observacion25 + "', `observacionEva26`='" + observacion26 + "', `observacionEva27`='" + observacion27 + "', `observacionEva28`='" + observacion28 + "',"
                    + " `observacionEva29`='" + observacion29 + "', `observacionEva30`='" + observacion30 + "', `observacionEva31`='" + observacion31 + "', `observacionEva32`='" + observacion32 + "', `observacionEva33`='" + observacion33 + "', `observacionEva34`='" + observacion34 + "', `observacionEva35`='" + observacion35 + "', `observacionEva36`='" + observacion36 + "', `observacionEva37`='" + observacion37 + "', `observacionEva38`='" + observacion38 + "' WHERE issnRevista = '" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;

        }

        public void enviarCorreoConfirmaLatindex(revistaConfirmada revista, basicosConfirmados basicos, presentacionConfirmados presentacion,
                gestionConfirmados gestion, contenidoConfirmados contenido, enLineaConfirmados enLinea, double notaLatindex, String indexada, String fechaProxEva) {

            String para = revista.getCorreo();
            //String para = "guillermo.murillogoussen@ucr.ac.cr";
            String desde = "REVISTAS@ucr.ac.cr";
            String asunto = "Resultado de Evaluación Latindex";

            String mailhost = "smtp.ucr.ac.cr";
            String mailer = "smtpsend";

            String usuario = "REVISTAS@ucr.ac.cr";
            String password = "l4t!nd3xucr";

            boolean verbose = true;
            boolean auth = true;
            String prot = "smtp";

            String catalogo = indexada;

            try {

                Properties props = System.getProperties();
                props.put("mail." + prot + ".auth", "true");

                Session session = Session.getInstance(props, null);

                Message msg = new MimeMessage(session);

                msg.setFrom(new InternetAddress(desde));

                msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(para, false));
                msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse("jorgelpolanco@gmail.com", false));

                msg.setSubject(asunto);

                String text = "Estimado(a) "+revista.getResponsable()+" a continuación el resultado de la Evaluación Latindex de su revista";
                text += "\nRevista: " + revista.getNombre();
                text += "\nFascículo: " + revista.getFasciculo();
                text += "\nIndexada: " + catalogo;

                text += "\n\nCARACTERÍSTICAS BÁSICAS";
                text += "\n1. Responsables editoriales: " + basicos.getResponsablesEva();
                text += "\nObservación: " + basicos.getObservacion1eva();
                text += "\n2. Generación continua de contenidos: " + basicos.getGeneracionContinuaEva();
                text += "\nObservación: " + basicos.getObservacion2eva();
                text += "\n. Identificación de los autores: " + basicos.getIdAutoresEva();
                text += "\nObservación: " + basicos.getObservacion3eva();
                text += "\n4. Entidad editora de la revista: " + basicos.getEntidadEditoraEva();
                text += "\nObservación: " + basicos.getObservacion4eva();
                text += "\n5. Instrucciones a los autores: " + basicos.getInstruccionesAutoresEva();
                text += "\nObservación: " + basicos.getObservacion5eva();
                text += "\n6. Sistema de arbitraje: " + basicos.getSistemaArbitrajeEva();
                text += "\nObservación: " + basicos.getObservacion6eva();
                text += "\n7. ISSN: " + basicos.getIssnCriterioEva();
                text += "\nObservación: " + basicos.getObservacion7eva();

                text += "\n\nCARACTERÍSTICAS DE PRESENTACIÓN";
                text += "\n8. Navegación y funcionalidad en el acceso a contenidos: " + presentacion.getNavegacionEva();
                text += "\nObservación: " + presentacion.getObservacion8eva();
                text += "\n9. Acceso histórico al contenido: " + presentacion.getAccesoHistoricoEva();
                text += "\nObservación: " + presentacion.getObservacion9eva();
                text += "\n10. Mención de periodicidad: " + presentacion.getMencionPeriodicidadEva();
                text += "\nObservación: " + presentacion.getObservacion10eva();
                text += "\n11. Membrete bibliográfico al inicio del artículo: " + presentacion.getMembreteInicioEva();
                text += "\nObservación: " + presentacion.getObservacion11eva();
                text += "\n12. Afiliación institucional de los miembros de los cuerpos editoriales: " + presentacion.getAfiliacionCuerposEditorialesEva();
                text += "\nObservación: " + presentacion.getObservacion12eva();
                text += "\n13. Afiliación de los autores: " + presentacion.getAfiliacionAutoresEva();
                text += "\nObservación: " + presentacion.getObservacion13eva();
                text += "\n14. Fechas de recepción y aceptación de originales: " + presentacion.getFechasRecepcionAceptacionEva();
                text += "\nObservación: " + presentacion.getObservacion14eva();

                text += "\n\nCARACTERÍSTICAS DE GESTIÓN Y POLÍTICA EDITORIAL";
                text += "\n15. Definición de la revista: " + gestion.getDefinicionRevistaEva();
                text += "\nObservación: " + gestion.getObservacion15eva();
                text += "\n16. Autores externos: " + gestion.getPorcentajeAutoresExternosEva();
                text += "\nObservación: " + gestion.getObservacion16eva();
                text += "\n17. Apertura editorial: " + gestion.getPorcentajeAperturaEditorialEva();
                text += "\nObservación: " + gestion.getObservacion17eva();
                text += "\n18. Servicios de información: " + gestion.getServiciosInformacionEva();
                text += "\nObservación: " + gestion.getObservacion18eva();
                text += "\n19. Cumplimiento de periodicidad: " + gestion.getCumplimientoPeriodicidadEva();
                text += "\nObservación: " + gestion.getObservacion19eva();
                text += "\n20. Políticas de acceso y reuso: " + gestion.getPoliticaAccesoReusoEva();
                text += "\nObservación: " + gestion.getObservacion20eva();
                text += "\n21. Adopción de códigos de ética: " + gestion.getCodigoEticaEva();
                text += "\nObservación: " + gestion.getObservacion21eva();
                text += "\n22. Detección de plagio: " + gestion.getDeteccionPlagioEva();
                text += "\nObservación: " + gestion.getObservacion22eva();

                text += "\n\nCARACTERÍSTICAS DE CONTENIDO";
                text += "\n23. Contenido original: " + contenido.getPorcentajeContenidoOriginalEva();
                text += "\nObservación: " + contenido.getObservacion23eva();
                text += "\n24. Elaboración de las referencias bibliográficas: " + contenido.getReferenciasBibliograficasEva();
                text += "\nObservación: " + contenido.getObservacion24eva();
                text += "\n25. Exigencia de originalidad: " + contenido.getExigenciaOriginalidadEva();
                text += "\nObservación: " + contenido.getObservacion25eva();
                text += "\n26. Resumen: " + contenido.getResumenEva();
                text += "\nObservación: " + contenido.getObservacion26eva();
                text += "\n27. Resumen en dos idiomas: " + contenido.getResumenDosIdiomasEva();
                text += "\nObservación: " + contenido.getObservacion27eva();
                text += "\n28. Palabras clave: " + contenido.getPalabrasEva();
                text += "\nObservación: " + contenido.getObservacion28eva();
                text += "\n29. Palabras clave en dos idiomas: " + contenido.getPalabrasDosIdiomasEva();
                text += "\nObservación: " + contenido.getObservacion29eva();
                text += "\n30. Cantidad de artículos publicados por año: " + contenido.getCantidadArticulosAnhoEva();
                text += "\nObservación: " + contenido.getObservacion30eva();

                text += "\n\nCARACTERÍSTICAS DE REVISTAS EN LÍNEA";
                text += "\n31. Uso de protocolos de interoperabilidad: " + enLinea.getInteroperabilidadEva();
                text += "\nObservación: " + enLinea.getObservacion31eva();
                text += "\n32. Uso de diferentes formatos de edición: " + enLinea.getFormatosEdicionEva();
                text += "\nObservación: " + enLinea.getObservacion32eva();
                text += "\n33. Servicios de valor agregado: " + enLinea.getValorAgregadoEva();
                text += "\nObservación: " + enLinea.getObservacion33eva();
                text += "\n34. Servicios de interactividad con el lector: " + enLinea.getInteractividadEva();
                text += "\nObservación: " + enLinea.getObservacion34eva();
                text += "\n35. Buscadores: " + enLinea.getBuscadoresEva();
                text += "\nObservación: " + enLinea.getObservacion35eva();
                text += "\n36. Uso de identificadores de recursos uniforme: " + enLinea.getIdentificadoresDeRecursoEva();
                text += "\nObservación: " + enLinea.getObservacion36eva();
                text += "\n37. Uso de estadísticas: " + enLinea.getEstadisticasEva();
                text += "\nObservación: " + enLinea.getObservacion37eva();
                text += "\n38. Políticas de preservación digital: " + enLinea.getPoliticaPreservacionEva();
                text += "\nObservación: " + enLinea.getObservacion38eva();
                text += "\n\n**Fecha de su próxima Evaluación Latindex**: " + fechaProxEva;

                msg.setText(text);

                msg.setHeader("X-Mailer", mailer);
                msg.setSentDate(new Date());

                SMTPTransport t = (SMTPTransport) session.getTransport(prot);

                try {
                    if (auth) {
                        t.connect(mailhost, usuario, password);
                    } else {
                        t.connect();
                    }
                    t.sendMessage(msg, msg.getAllRecipients());
                } finally {
                    if (verbose) {
                        System.out.println("Respuesta al envío de confirmación Latindex: " + t.getLastServerResponse());
                    }
                    t.close();
                }

                /*String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/Resultado-Latindex-" + revista.getNombre() + ".txt";
                PrintWriter pw = new PrintWriter(new FileOutputStream(nameOfTextFile));
                pw.println(text);
                //clean up
                pw.close();*/

            } catch (Exception e) {
                /*
                         * Handle SMTP-specific exceptions.
                 */
                System.out.println("Exception: " + e);
                if (verbose) {
                e.printStackTrace();
                }
        }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <div class="container">
        <%            request.setCharacterEncoding("UTF-8");

            HttpSession misession = request.getSession(true);
            revistaConfirmada revistaRecuperada = (revistaConfirmada) misession.getAttribute("revistaRecuperada");
            revistaRecuperada.setEstado(2); //0 significa sin evaluar, 1 evaluada, 2 confirmada
            String fechaHoy = new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date());
            revistaRecuperada.setFechaConfirmacion(fechaHoy);
            conexionBD con = new conexionBD();

            con.actualizarDatosRevista(revistaRecuperada.getIssn(), revistaRecuperada.getFasciculo(), revistaRecuperada.getFechaConfirmacion(), fechaProxEva, revistaRecuperada.getEstado());

            basicosConfirmados basicosRecuperados = (basicosConfirmados) misession.getAttribute("basicosRecuperados");
            con.insertarConfirmaBasicos(revistaRecuperada.getIssn(), basicosRecuperados.getResponsablesEva(), basicosRecuperados.getGeneracionContinuaEva(), basicosRecuperados.getIdAutoresEva(), basicosRecuperados.getEntidadEditoraEva(), basicosRecuperados.getInstruccionesAutoresEva(), basicosRecuperados.getSistemaArbitrajeEva(), basicosRecuperados.getIssnCriterioEva());

            contenidoConfirmados contenidoRecuperados = (contenidoConfirmados) misession.getAttribute("contenidoRecuperados");
            boolean resumenEva;
            boolean resumenDosEva;
            boolean palabrasEva;
            boolean palabrasDosEva;
            
            if(contenidoRecuperados.getResumenEva().equals("Sí cumple"))
            {
                resumenEva = true;
            }
            else
            {
                resumenEva = false;
            }
            
            if(contenidoRecuperados.getResumenDosIdiomasEva().equals("Sí cumple"))
            {
                resumenDosEva = true;
            }
            else
            {
                resumenDosEva = false;
            }
            
            if(contenidoRecuperados.getPalabrasEva().equals("Sí cumple"))
            {
                palabrasEva = true;
            }
            else
            {
                palabrasEva = false;
            }
            
            if(contenidoRecuperados.getPalabrasDosIdiomasEva().equals("Sí cumple"))
            {
                palabrasDosEva = true;
            }
            else
            {
                palabrasDosEva = false;
            }
            
            con.insertarConfirmaContenido(revistaRecuperada.getIssn(), Integer.parseInt(contenidoRecuperados.getDocumentosOriginalesEva()), Integer.parseInt(contenidoRecuperados.getOtroTipoEva()), contenidoRecuperados.getReferenciasBibliograficasEva(), contenidoRecuperados.getExigenciaOriginalidadEva(), resumenEva, resumenDosEva, palabrasEva, palabrasDosEva, Integer.parseInt(contenidoRecuperados.getCantidadArticulosAnhoEva()));

            enLineaConfirmados enLineaRecuperados = (enLineaConfirmados) misession.getAttribute("enLineaRecuperados");
            boolean formatosEva;
            boolean identificadoresEva;
            
            if(enLineaRecuperados.getFormatosEdicionEva().equals("Sí cumple"))
            {
                formatosEva = true;
            }
            else
            {
                formatosEva = false;
            }
            
            if(enLineaRecuperados.getIdentificadoresDeRecursoEva().equals("Sí cumple"))
            {
                identificadoresEva = true;
            }
            else
            {
                identificadoresEva = false;
            }
            
            con.insertarConfirmaEnLinea(revistaRecuperada.getIssn(), enLineaRecuperados.getInteroperabilidadEva(), formatosEva, enLineaRecuperados.getValorAgregadoEva(), enLineaRecuperados.getInteractividadEva(), enLineaRecuperados.getBuscadoresEva(), identificadoresEva, enLineaRecuperados.getEstadisticasEva(), enLineaRecuperados.getPoliticaPreservacionEva());

            presentacionConfirmados presentacionRecuperados = (presentacionConfirmados) misession.getAttribute("presentacionRecuperados");
            boolean navegacionEva;
            boolean accesoEva;
            boolean membreteInicioEva;
            boolean afiliacionAutoresEva;
            boolean fechasEva;
            
            if(presentacionRecuperados.getNavegacionEva().equals("Sí cumple"))
            {
                navegacionEva = true;
            }
            else
            {
                navegacionEva = false;
            }
            
            if(presentacionRecuperados.getAccesoHistoricoEva().equals("Sí cumple"))
            {
                accesoEva = true;
            }
            else
            {
                accesoEva = false;
            }
            
            if(presentacionRecuperados.getMembreteInicioEva().equals("Sí cumple"))
            {
                membreteInicioEva = true;
            }
            else
            {
                membreteInicioEva = false;
            }
            
            if(presentacionRecuperados.getAfiliacionAutoresEva().equals("Sí cumple"))
            {
                afiliacionAutoresEva = true;
            }
            else
            {
                afiliacionAutoresEva = false;
            }
            
            if(presentacionRecuperados.getFechasRecepcionAceptacionEva().equals("Sí cumple"))
            {
                fechasEva = true;
            }
            else
            {
                fechasEva = false;
            }
            
            con.insertarConfirmaPresentacion(revistaRecuperada.getIssn(), navegacionEva, accesoEva, presentacionRecuperados.getMembreteInicioEva(), membreteInicioEva, presentacionRecuperados.getAfiliacionCuerposEditorialesEva(), afiliacionAutoresEva, fechasEva);

            gestionConfirmados gestionRecuperados = (gestionConfirmados) misession.getAttribute("gestionRecuperados");
            con.insertarConfirmaGestion(revistaRecuperada.getIssn(), gestionRecuperados.getDefinicionRevistaEva(), Integer.parseInt(gestionRecuperados.getAutoresExternosEva()), Integer.parseInt(gestionRecuperados.getAutoresInternosEva()), Integer.parseInt(gestionRecuperados.getMiembrosInternosEva()), Integer.parseInt(gestionRecuperados.getMiembrosExternosEva()), gestionRecuperados.getServiciosInformacionEva(), gestionRecuperados.getCumplimientoPeriodicidadEva(), gestionRecuperados.getPoliticaAccesoReusoEva(), gestionRecuperados.getCodigoEticaEva(), gestionRecuperados.getDeteccionPlagioEva());

            boolean indexBD = true;
            if (indexada.equals("NO")) {
                indexBD = false;
            }

            //con.insertarNotaLatindex(revistaRecuperada.getIssn(), notaLatindex, 0.0000, indexBD);
            con.actualizarNotaLatindex(revistaRecuperada.getIssn(), notaLatindex);
            con.actualizarEstadoIndexada(revistaRecuperada.getIssn(), indexBD);

            con.actualizarObservacionesEvaluacion(revistaRecuperada.getIssn(), basicosRecuperados.getObservacion1eva(), basicosRecuperados.getObservacion2eva(), basicosRecuperados.getObservacion3eva(), basicosRecuperados.getObservacion4eva(), basicosRecuperados.getObservacion5eva(), basicosRecuperados.getObservacion6eva(), basicosRecuperados.getObservacion7eva(),
                    presentacionRecuperados.getObservacion8eva(), presentacionRecuperados.getObservacion9eva(), presentacionRecuperados.getObservacion10eva(), presentacionRecuperados.getObservacion11eva(), presentacionRecuperados.getObservacion12eva(), presentacionRecuperados.getObservacion13eva(), presentacionRecuperados.getObservacion14eva(),
                    gestionRecuperados.getObservacion15eva(), gestionRecuperados.getObservacion16eva(), gestionRecuperados.getObservacion17eva(), gestionRecuperados.getObservacion18eva(), gestionRecuperados.getObservacion19eva(), gestionRecuperados.getObservacion20eva(), gestionRecuperados.getObservacion21eva(), gestionRecuperados.getObservacion22eva(),
                    contenidoRecuperados.getObservacion23eva(), contenidoRecuperados.getObservacion24eva(), contenidoRecuperados.getObservacion25eva(), contenidoRecuperados.getObservacion26eva(), contenidoRecuperados.getObservacion27eva(), contenidoRecuperados.getObservacion28eva(), contenidoRecuperados.getObservacion29eva(), contenidoRecuperados.getObservacion30eva(),
                    enLineaRecuperados.getObservacion31eva(), enLineaRecuperados.getObservacion32eva(), enLineaRecuperados.getObservacion33eva(), enLineaRecuperados.getObservacion34eva(), enLineaRecuperados.getObservacion35eva(), enLineaRecuperados.getObservacion36eva(), enLineaRecuperados.getObservacion37eva(), enLineaRecuperados.getObservacion38eva());

            con.insertarObservacionesConfirmacion(revistaRecuperada.getIssn(), basicosRecuperados.getObservacion1confirma(), basicosRecuperados.getObservacion2confirma(), basicosRecuperados.getObservacion3confirma(), basicosRecuperados.getObservacion4confirma(), basicosRecuperados.getObservacion5confirma(), basicosRecuperados.getObservacion6confirma(), basicosRecuperados.getObservacion7confirma(),
                    presentacionRecuperados.getObservacion8confirma(), presentacionRecuperados.getObservacion9confirma(), presentacionRecuperados.getObservacion10confirma(), presentacionRecuperados.getObservacion11confirma(), presentacionRecuperados.getObservacion12confirma(), presentacionRecuperados.getObservacion13confirma(), presentacionRecuperados.getObservacion14confirma(),
                    gestionRecuperados.getObservacion15confirma(), gestionRecuperados.getObservacion16confirma(), gestionRecuperados.getObservacion17confirma(), gestionRecuperados.getObservacion18confirma(), gestionRecuperados.getObservacion19confirma(), gestionRecuperados.getObservacion20confirma(), gestionRecuperados.getObservacion21confirma(), gestionRecuperados.getObservacion22confirma(),
                    contenidoRecuperados.getObservacion23confirma(), contenidoRecuperados.getObservacion24confirma(), contenidoRecuperados.getObservacion25confirma(), contenidoRecuperados.getObservacion26confirma(), contenidoRecuperados.getObservacion27confirma(), contenidoRecuperados.getObservacion28confirma(), contenidoRecuperados.getObservacion29confirma(), contenidoRecuperados.getObservacion30confirma(),
                    enLineaRecuperados.getObservacion31confirma(), enLineaRecuperados.getObservacion32confirma(), enLineaRecuperados.getObservacion33confirma(), enLineaRecuperados.getObservacion34confirma(), enLineaRecuperados.getObservacion35confirma(), enLineaRecuperados.getObservacion36confirma(), enLineaRecuperados.getObservacion37confirma(), enLineaRecuperados.getObservacion38confirma());
            
            con.enviarCorreoConfirmaLatindex(revistaRecuperada, basicosRecuperados, presentacionRecuperados, gestionRecuperados, contenidoRecuperados,
                    enLineaRecuperados, notaLatindex, indexada, fechaProxEva);
                
            misession.setAttribute("revistaRecuperada", revistaRecuperada);

            if (revistaRecuperada.getEsUCR()) {
                response.sendRedirect("confirmaUCRIndex.jsp");
            } else {
                response.sendRedirect("tabla.jsp");
            }

        %>

    </body>
</html>

