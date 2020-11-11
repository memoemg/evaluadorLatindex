<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.criteriosEnLinea"%>
<%@page import="java.io.*"  %>
<%@page import="java.sql.*"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="java.util.Properties"%>
<%@page import="ucrindex.Revista"%>
<%@page import="ucrindex.criteriosBasicos"%>
<%@page import="ucrindex.criteriosGestion"%>
<%@page import="ucrindex.criteriosEnLinea"%>
<%@page import="ucrindex.criteriosContenido"%>
<%@page import="ucrindex.criteriosPresentacion"%>
<%@page import="ucrindex.solicitudUCRIndex"%>



<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    solicitudUCRIndex formularioUCRIndex = new solicitudUCRIndex();
    formularioUCRIndex.setMencionMesesPublicacion(request.getParameter("UCR1"));
    formularioUCRIndex.setMiembrosNacionales(Integer.parseInt(request.getParameter("miembrosNacionales")));
    formularioUCRIndex.setMiembrosInternacionales(Integer.parseInt(request.getParameter("miembrosInternacionales")));
    formularioUCRIndex.setArticulosEvaInternos(Integer.parseInt(request.getParameter("evaluadoresInternos")));
    formularioUCRIndex.setArticulosEvaExternos(Integer.parseInt(request.getParameter("evaluadoresExternos")));
    formularioUCRIndex.setDiversidadIdioma(request.getParameter("UCR4") != null);
    formularioUCRIndex.setDocumentosNacionales(Integer.parseInt(request.getParameter("articulosNacionales")));
    formularioUCRIndex.setDocumentosInternacionales(Integer.parseInt(request.getParameter("articulosInternacionales")));
    formularioUCRIndex.setRigurosos(Integer.parseInt(request.getParameter("indicesRigurosos")));
    formularioUCRIndex.setMedianos(Integer.parseInt(request.getParameter("indicesMedianos")));
    formularioUCRIndex.setPoco(Integer.parseInt(request.getParameter("indicesPoco")));
    formularioUCRIndex.setNoSelectivos(Integer.parseInt(request.getParameter("indicesNo")));
    formularioUCRIndex.setGuiaEvaluacion(request.getParameter("UCR10") != null);
    formularioUCRIndex.setListaEvaluadores(request.getParameter("UCR11") != null);

    formularioUCRIndex.setObservacionSolicitudU1(request.getParameter("observacionUCR1"));
    formularioUCRIndex.setObservacionSolicitudU2(request.getParameter("observacionUCR2"));
    formularioUCRIndex.setObservacionSolicitudU3(request.getParameter("observacionUCR3"));
    formularioUCRIndex.setObservacionSolicitudU4(request.getParameter("observacionUCR4"));
    formularioUCRIndex.setObservacionSolicitudU5(request.getParameter("observacionUCR5"));
    formularioUCRIndex.setObservacionSolicitudU6(request.getParameter("observacionUCR6"));
    formularioUCRIndex.setObservacionSolicitudU7(request.getParameter("observacionUCR7"));
    formularioUCRIndex.setObservacionSolicitudU8(request.getParameter("observacionUCR8"));
    formularioUCRIndex.setObservacionSolicitudU9(request.getParameter("observacionUCR9"));
    formularioUCRIndex.setObservacionSolicitudU10(request.getParameter("observacionUCR10"));
    formularioUCRIndex.setObservacionSolicitudU11(request.getParameter("observacionUCR11"));

    misession.setAttribute("formularioUCRIndex", formularioUCRIndex);
%>

<% Class.forName("com.mysql.jdbc.Driver"); %>

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
        public int insertarRevista(String nombre, String organismo, String issn, String fasciculo, String url, String solicitante, String responsable, String correo, String fechaSolicitud, String fechaEvaluacion, String fechaConfirmacion, boolean esUCR, int estado) {
            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `datosrevista`(`nombre`, `organismo`, `issn`, `fasciculo`, `url`, `solicitante`, `responsable`, `correo`, `fechaSolicitud`, `fechaEvaluacion`, `fechaConfirmacion`, `esUCR`, `estado`, `consecutivo`) VALUES ('" + nombre + "', '" + organismo
                    + "', '" + issn + "', '" + fasciculo + "', '" + url + "', '" + solicitante + "', '" + responsable + "', '" + correo + "', '" + fechaSolicitud + "', '" + fechaEvaluacion + "', '" + fechaConfirmacion + "', " + esUCR + ", " + estado + ", 0);";

            //System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarCriteriosBasicos(String issnRevista, String responsables, String generacionContinua,
                String identificacionAutores, String entidadEditora, String instruccionesAutores, String sistemaArbitraje,
                String issnCriterio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `criteriosbasicos`(`issnRevista`, `responsables`, `generacionContinua`, `identificacionAutores`, `entidadEditora`, `instruccionesAutores`, `sistemaArbitraje`, `issnCriterio`) VALUES ('" + issnRevista + "', '" + responsables + "', '" + generacionContinua + "', '" + identificacionAutores + "', '" + entidadEditora + "', '" + instruccionesAutores + "', '" + sistemaArbitraje + "', '" + issnCriterio + "');";
            //System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarCriteriosGestion(String issnRevista, String definicionRevista, int autoresExternos, int autoresInternos, int miembrosInternos, int miembrosExternos, String serviciosInformacion, String cumplimientoPeriodicidad, String politicaAccesoReuso, String codigoEtica, String deteccionPlagio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `criteriosgestion`(`issnRevista`, `definicionRevista`, `autoresExternos`, `autoresInternos`, `miembrosInternos`, `miembrosExternos`, `serviciosInformacion`, `cumplimientoPeriodicidad`, `politicaAccesoReuso`, `codigoEtica`, `deteccionPlagio`) VALUES ('" + issnRevista + "', '" + definicionRevista + "', " + autoresExternos + ", " + autoresInternos + ", " + miembrosInternos + ", " + miembrosExternos + ", '" + serviciosInformacion + "', '" + cumplimientoPeriodicidad + "', '" + politicaAccesoReuso + "', '" + codigoEtica + "', '" + deteccionPlagio + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarCriteriosEnLinea(String issnRevista, String interoperabilidad, boolean formatosEdicion, String valorAgregado, String interactividad, String buscadores, boolean identificadoresDeRecurso, String estadisticas, String politicaPreservacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `criteriosenlinea`(`issnRevista`, `interoperabilidad`, `formatosEdicion`, `valorAgregado`, `interactividad`, `buscadores`, `identificadoresDeRecurso`, `estadisticas`, `politicaPreservacion`) VALUES ('" + issnRevista + "', '" + interoperabilidad + "', " + formatosEdicion + ", '" + valorAgregado + "', '" + interactividad + "', '" + buscadores + "', " + identificadoresDeRecurso + ", '" + estadisticas + "', '" + politicaPreservacion + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarCriteriosContenido(String issnRevista, int documentosOriginales, int otrosTipos, String referenciasBibliograficas, String exigenciaOriginalidad, boolean resumen, boolean resumenDosIdiomas, boolean palabras, boolean palabrasDosIdiomas, int cantidadArticulosAnho) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `criterioscontenido`(`issnRevista`, `documentosOriginales`, `otrosTipos`, `referenciasBibliograficas`, `exigenciaOriginalidad`, `resumen`, `resumenDosIdiomas`, `palabras`, `palabrasDosIdiomas`, `cantidadArticulosAnho`) VALUES ('" + issnRevista + "', " + documentosOriginales + ", " + otrosTipos + ", '" + referenciasBibliograficas + "', '" + exigenciaOriginalidad + "', " + resumen + ", " + resumenDosIdiomas + ", " + palabras + ", " + palabrasDosIdiomas + ", " + cantidadArticulosAnho + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarCriteriosPresentacion(String issnRevista, boolean navegacion, boolean accesoHistorico, String mencionPeriodicidad, boolean membreteInicio, String afiliacionCuerposEditoriales, boolean afiliacionAutores, boolean fechasRecepcionAceptacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `criteriospresentacion`(`issnRevista`, `navegacion`, `accesoHistorico`, `mencionPeriodicidad`, `membreteInicio`, `afiliacionCuerposEditoriales`, `afiliacionAutores`, `fechasRecepcionAceptacion`) VALUES ('" + issnRevista + "', " + navegacion + ", " + accesoHistorico + ", '" + mencionPeriodicidad + "', " + membreteInicio + ", '" + afiliacionCuerposEditoriales + "', " + afiliacionAutores + ", " + fechasRecepcionAceptacion + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesSolicitud(String issnRevista, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11, String observacion12, String observacion13, String observacion14, String observacion15,
                String observacion16, String observacion17, String observacion18, String observacion19, String observacion20, String observacion21, String observacion22, String observacion23, String observacion24, String observacion25, String observacion26, String observacion27, String observacion28, String observacion29, String observacion30, String observacion31, String observacion32, String observacion33,
                String observacion34, String observacion35, String observacion36, String observacion37, String observacion38) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionessolicitudlatindex`(`issnrevista`, `observacion1`, `observacion2`, `observacion3`, `observacion4`, `observacion5`, `observacion6`, `observacion7`, `observacion8`, `observacion9`, `observacion10`, `observacion11`,"
                    + " `observacion12`, `observacion13`, `observacion14`, `observacion15`, `observacion16`, `observacion17`, `observacion18`, `observacion19`, `observacion20`, `observacion21`, `observacion22`, `observacion23`, `observacion24`, `observacion25`, `observacion26`, `observacion27`, `observacion28`,"
                    + " `observacion29`, `observacion30`, `observacion31`, `observacion32`, `observacion33`, `observacion34`, `observacion35`, `observacion36`, `observacion37`, `observacion38`) VALUES ('" + issnRevista + "', '" + observacion1 + "', '" + observacion2 + "', '" + observacion3 + "', '" + observacion4 + "', '" + observacion5 + "', '" + observacion6 + "', '" + observacion7 + "', '" + observacion8 + "', '" + observacion9 + "', '" + observacion10
                    + "', '" + observacion11 + "', '" + observacion12 + "', '" + observacion13 + "', '" + observacion14 + "', '" + observacion15 + "', '" + observacion16 + "', '" + observacion17 + "', '" + observacion18 + "', '" + observacion19 + "', '" + observacion20 + "', '" + observacion21 + "', '" + observacion22 + "', '" + observacion23 + "', '" + observacion24 + "', '" + observacion25 + "', '" + observacion26 + "', '" + observacion27 + "', '" + observacion28 + "', '" + observacion29 + "', '" + observacion30 + "', '" + observacion31 + "', '" + observacion32 + "', '" + observacion33
                    + "', '" + observacion34 + "', '" + observacion35 + "', '" + observacion36 + "', '" + observacion37 + "', '" + observacion38 + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarSolicitudUCRIndex(String issnRevista, String mencionMesesPublicacion, int miembrosNacionales, int miembrosInternacionales, int articulosEvaInternos, int articulosEvaExternos, boolean diversidadIdioma, int documentosNacionales, int documentosInternacionales, int rigurosos, int medianos, int poco, int noSelectivos, boolean guiaEvaluacion, boolean listaEvaluadores) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `preucrindex`(`issnRevista`, `mencionMesesPublicacion`, `miembrosNacionales`, `miembrosInternacionales`, `articulosEvaInternos`, `articulosEvaExternos`, `diversidadIdioma`, `documentosNacionales`, `documentosInternacionales`, `rigurosos`, `medianos`, `poco`, `noSelectivos`, `guiaEvaluacion`, `listaEvaluadores`) VALUES ('" + issnRevista + "', '" + mencionMesesPublicacion + "', " + miembrosNacionales + ", " + miembrosInternacionales + ", " + articulosEvaInternos + ", " + articulosEvaExternos + ", " + diversidadIdioma + ", " + documentosNacionales + ", " + documentosInternacionales + ", " + rigurosos + ", " + medianos
                    + ", " + poco + ", " + noSelectivos + ", " + guiaEvaluacion + ", " + listaEvaluadores + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesSolicitudUCRIndex(String issnRevista, String criterio1, String criterio2, String criterio3, String criterio4, String criterio5, String criterio6, String criterio7, String criterio8, String criterio9, String criterio10, String criterio11) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionessolicituducrindex`(`issnRevista`, `observacionSolicitudU1`, `observacionSolicitudU2`, `observacionSolicitudU3`, `observacionSolicitudU4`, `observacionSolicitudU5`, `observacionSolicitudU6`, `observacionSolicitudU7`, `observacionSolicitudU8`, `observacionSolicitudU9`, `observacionSolicitudU10`, `observacionSolicitudU11`) VALUES ('" + issnRevista + "', '" + criterio1 + "', '" + criterio2 + "', '" + criterio3 + "', '" + criterio4 + "', '" + criterio5 + "', '" + criterio6 + "', '" + criterio7 + "', '" + criterio8 + "', '" + criterio9 + "', '" + criterio10 + "', '" + criterio11 + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public void enviarCorreoNotificacion(String nombreRevista, String nombreSolicitante, String correoSolicitante, String fecha) {

            String para = correoSolicitante;
            String desde = "REVISTAS@ucr.ac.cr";
            String copia = "jorge.polanco@ucr.ac.cr";
            String asunto = "Recepción de Solicitud de Evaluación Latindex";

            String mailhost = "smtp.ucr.ac.cr";
            String mailer = "smtpsend";

            String usuario = "REVISTAS@ucr.ac.cr";
            String password = "l4t!nd3xucr";

            boolean verbose = true;
            boolean auth = true;
            String prot = "smtp";

            try {

                Properties props = System.getProperties();
                props.put("mail." + prot + ".auth", "true");

                Session session = Session.getInstance(props, null);

                Message msg = new MimeMessage(session);

                msg.setFrom(new InternetAddress(desde));

                msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(para, false));
                msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse(copia, false));

                msg.setSubject(asunto);

                String text = "Su solicitud de evaluación fue recibida exitosamente\nRevista: " + nombreRevista + "\nSolicitante: " + nombreSolicitante + "\nFecha: " + fecha;

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
                        System.out.println("Respuesta: " + t.getLastServerResponse());
                    }
                    t.close();
                }

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

        public void guardarArchivo(String nombre, String organismo, String url, String solicitante, String issn, String fechaHoy,
                String criterio31, boolean criterio32, String criterio33, String criterio34, String criterio35, boolean criterio36, String criterio37, String criterio38,
                String ocriterio31, String ocriterio32, String ocriterio33, String ocriterio34, String ocriterio35, String ocriterio36, String ocriterio37, String ocriterio38,
                String mencionMeses, String miembrosU, String evaluadoresU, boolean diversidadIdioma, String autoresU, String indices, boolean guiaU, boolean listaU,
                String ocriterioU1, String ocriterioU2, String ocriterioU3, String ocriterioU4, String ocriterioU5, String ocriterioU6, String ocriterioU7, String ocriterioU8, String ocriterioU9, String ocriterioU10, String ocriterioU11) {

            String datosUnidos = "Datos de la revista: \nRevista: " + nombre + "\nOrganismo: " + organismo + "\nISSN: " + issn + "\nURL: " + url + "\nSolicitante: " + solicitante + "\nFecha: " + fechaHoy;

            datosUnidos = datosUnidos + "\n\nPreevaluación Latindex: \n" + "Criterio 31 : " + criterio31 + "\nCriterio 32 : " + criterio32 + "\nCriterio 33 : " + criterio33
                    + "\nCriterio 34 : " + criterio34 + "\nCriterio 35 : " + criterio35 + "\nCriterio 36 : " + criterio36 + "\nCriterio 37 : " + criterio37 + "\nCriterio 38 : " + criterio38;

            datosUnidos = datosUnidos + "\n\nObservaciones Latindex: \n" + "Observación 31 : " + ocriterio31 + "\nObservación 32 : " + ocriterio32 + "\nObservación 33 : " + ocriterio33
                    + "\nObservación 34 : " + ocriterio34 + "\nObservación 35 : " + ocriterio35 + "\nObservación 36 : " + ocriterio36 + "\nObservación 37 : " + ocriterio37 + "\nObservación 38 : " + ocriterio38;

            datosUnidos = datosUnidos + "\n\nCriterios UCRIndex: \n" + "Mención meses : "+ mencionMeses + "\nMiembros Editoriales : " + miembrosU + "\nEvaluadores : " + evaluadoresU + "\nDiversidad de idioma : " + diversidadIdioma
                    + "\nAutores : " + autoresU + "\nÍndices 35 : " + indices + "\nGuía de evaluación : " + guiaU + "\nLista de evaluadores : " + listaU;

            datosUnidos = datosUnidos + "\n\nObservaciones UCRÍndex: \n" + "Observación 1 : " + ocriterioU1 + "\nObservación 2 : " + ocriterioU2 + "\nObservación 3 : " + ocriterioU3
                    + "\nObservación 4 : " + ocriterioU4 + "\nObservación 5 : " + ocriterioU5 + "\nObservación 6 : " + ocriterioU6 + "\nObservación 7 : " + ocriterioU7 + "\nObservación 8 : " + ocriterioU8
                    + "\nObservación 9 : " + ocriterioU9 + "\nObservación 10 : " + ocriterioU10 + "\nObservación 11: " + ocriterioU11;

            String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/" + nombre + "-enLinea-" + fechaHoy + ".txt";
            try {
                PrintWriter pw = new PrintWriter(new FileOutputStream(nameOfTextFile));
                pw.println(datosUnidos);
                //clean up
                pw.close();
            } catch (IOException e) {
                System.err.println(e.getMessage());
            }

        }

    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Solicitud de Evaluación Latindex y UCRÍndex</title>
    </head>
    <body>
        <div class="container">
            <%
                Revista revistaSolicitante = (Revista) misession.getAttribute("revistaSolicitante");
                revistaSolicitante.setEstado(0); //0 significa sin evaluar, 1 evaluada, 2 confirmada
                conexionBD con = new conexionBD();

                con.insertarRevista(revistaSolicitante.getNombre(), revistaSolicitante.getOrganismo(), revistaSolicitante.getIssn(), revistaSolicitante.getFasciculo(), revistaSolicitante.getUrl(),
                        revistaSolicitante.getSolicitante(), revistaSolicitante.getResponsable(), revistaSolicitante.getCorreo(), revistaSolicitante.getFechaSolicitud(), revistaSolicitante.getFechaEvaluacion(), revistaSolicitante.getFechaConfirmacion(),
                        revistaSolicitante.getEsUCR(), revistaSolicitante.getEstado());

                criteriosBasicos formularioBasicos = (criteriosBasicos) misession.getAttribute("formularioBasicos");
                con.insertarCriteriosBasicos(revistaSolicitante.getIssn(), formularioBasicos.getResponsables(), formularioBasicos.getGeneracionContinua(), formularioBasicos.getIdAutores(), formularioBasicos.getEntidadEditora(), formularioBasicos.getInstruccionesAutores(), formularioBasicos.getSistemaArbitraje(), formularioBasicos.getIssnCriterio());

                criteriosContenido formularioContenido = (criteriosContenido) misession.getAttribute("formularioContenido");
                con.insertarCriteriosContenido(revistaSolicitante.getIssn(), formularioContenido.getDocumentosOriginales(), formularioContenido.getOtroTipo(), formularioContenido.getReferenciasBibliograficas(), formularioContenido.getExigenciaOriginalidad(), formularioContenido.getResumen(), formularioContenido.getResumenDosIdiomas(), formularioContenido.getPalabras(), formularioContenido.getPalabrasDosIdiomas(), formularioContenido.getCantidadArticulosAnho());

                criteriosEnLinea formularioEnLinea = (criteriosEnLinea) misession.getAttribute("formularioEnLinea");
                con.insertarCriteriosEnLinea(revistaSolicitante.getIssn(), formularioEnLinea.getInteroperabilidad(), formularioEnLinea.getFormatosEdicion(), formularioEnLinea.getValorAgregado(), formularioEnLinea.getInteractividad(), formularioEnLinea.getBuscadores(), formularioEnLinea.getIdentificadoresDeRecurso(), formularioEnLinea.getEstadisticas(), formularioEnLinea.getPoliticaPreservacion());

                criteriosPresentacion formularioPresentacion = (criteriosPresentacion) misession.getAttribute("formularioPresentacion");
                con.insertarCriteriosPresentacion(revistaSolicitante.getIssn(), formularioPresentacion.getNavegacion(), formularioPresentacion.getAccesoHistorico(), formularioPresentacion.getMencionPeriodicidad(), formularioPresentacion.getMembreteInicio(), formularioPresentacion.getAfiliacionCuerposEditoriales(), formularioPresentacion.getAfiliacionAutores(), formularioPresentacion.getFechasRecepcionAceptacion());

                criteriosGestion formularioGestion = (criteriosGestion) misession.getAttribute("formularioGestion");
                con.insertarCriteriosGestion(revistaSolicitante.getIssn(), formularioGestion.getDefinicionRevista(), formularioGestion.getAutoresExternos(), formularioGestion.getAutoresInternos(), formularioGestion.getMiembrosInternos(), formularioGestion.getMiembrosExternos(), formularioGestion.getServiciosInformacion(), formularioGestion.getCumplimientoPeriodicidad(), formularioGestion.getPoliticaAccesoReuso(), formularioGestion.getCodigoEtica(), formularioGestion.getDeteccionPlagio());
                
                //guardar archivo
                String miembrosU = "Miembros nacionales " + formularioUCRIndex.getMiembrosNacionales() +" Miembros internacionales: " + formularioUCRIndex.getMiembrosInternacionales();
                String evaluadoresU = "Artículos con evaluadores internos: " + formularioUCRIndex.getArticulosEvaInternos() + " Artículos con evaluadores externos: " + formularioUCRIndex.getArticulosEvaExternos();
                String autoresU = "Documentos con autores nacionales: " + formularioUCRIndex.getDocumentosNacionales() + " Documentos con autores internacionales: " + formularioUCRIndex.getDocumentosInternacionales(); 
                String indices = "Rigurosos: " + formularioUCRIndex.getRigurosos() + " Medianamente: " + formularioUCRIndex.getMedianos() + " Poco: " + formularioUCRIndex.getPoco() + " No selectivos: " + formularioUCRIndex.getNoSelectivos();
                
                //con.guardarArchivo(revistaSolicitante.getNombre(), revistaSolicitante.getOrganismo(), revistaSolicitante.getUrl(), revistaSolicitante.getSolicitante(), revistaSolicitante.getIssn(), revistaSolicitante.getFechaSolicitud(), 
                //formularioEnLinea.getInteroperabilidad(), formularioEnLinea.getFormatosEdicion(), formularioEnLinea.getValorAgregado(), formularioEnLinea.getInteractividad(), formularioEnLinea.getBuscadores(), formularioEnLinea.getIdentificadoresDeRecurso(), formularioEnLinea.getEstadisticas(), formularioEnLinea.getPoliticaPreservacion(),
                //formularioEnLinea.getObservacion31(), formularioEnLinea.getObservacion32(), formularioEnLinea.getObservacion33(), formularioEnLinea.getObservacion34(), formularioEnLinea.getObservacion35(), formularioEnLinea.getObservacion36(), formularioEnLinea.getObservacion37(), formularioEnLinea.getObservacion38(),
                //        formularioUCRIndex.getMencionMesesPublicacion(), miembrosU, evaluadoresU, formularioUCRIndex.getDiversidadIdioma(), autoresU, indices, formularioUCRIndex.getGuiaEvaluacion(), formularioUCRIndex.getGuiaEvaluacion(), 
                //        formularioUCRIndex.getObservacionSolicitudU1(), formularioUCRIndex.getObservacionSolicitudU2(), formularioUCRIndex.getObservacionSolicitudU3(), formularioUCRIndex.getObservacionSolicitudU4(), 
                //        formularioUCRIndex.getObservacionSolicitudU5(), formularioUCRIndex.getObservacionSolicitudU6(), formularioUCRIndex.getObservacionSolicitudU7(), formularioUCRIndex.getObservacionSolicitudU8(), 
                //        formularioUCRIndex.getObservacionSolicitudU9(), formularioUCRIndex.getObservacionSolicitudU10(), formularioUCRIndex.getObservacionSolicitudU11());
                
                //insertar observacionesPreevaluacion
                con.insertarObservacionesSolicitud(revistaSolicitante.getIssn(), formularioBasicos.getObservacion1(), formularioBasicos.getObservacion2(), formularioBasicos.getObservacion3(), formularioBasicos.getObservacion4(), formularioBasicos.getObservacion5(), formularioBasicos.getObservacion6(), formularioBasicos.getObservacion7(),
                        formularioPresentacion.getObservacion8(), formularioPresentacion.getObservacion9(), formularioPresentacion.getObservacion10(), formularioPresentacion.getObservacion11(), formularioPresentacion.getObservacion12(), formularioPresentacion.getObservacion13(), formularioPresentacion.getObservacion14(),
                        formularioGestion.getObservacion15(), formularioGestion.getObservacion16(), formularioGestion.getObservacion17(), formularioGestion.getObservacion18(), formularioGestion.getObservacion19(), formularioGestion.getObservacion20(), formularioGestion.getObservacion21(), formularioGestion.getObservacion22(),
                        formularioContenido.getObservacion23(), formularioContenido.getObservacion24(), formularioContenido.getObservacion25(), formularioContenido.getObservacion26(), formularioContenido.getObservacion27(), formularioContenido.getObservacion28(), formularioContenido.getObservacion29(), formularioContenido.getObservacion30(),
                        formularioEnLinea.getObservacion31(), formularioEnLinea.getObservacion32(), formularioEnLinea.getObservacion33(), formularioEnLinea.getObservacion34(), formularioEnLinea.getObservacion35(), formularioEnLinea.getObservacion36(), formularioEnLinea.getObservacion37(), formularioEnLinea.getObservacion38());

                //insertar UCRIndex
                con.insertarSolicitudUCRIndex(revistaSolicitante.getIssn(), formularioUCRIndex.getMencionMesesPublicacion(), formularioUCRIndex.getMiembrosNacionales(), formularioUCRIndex.getMiembrosInternacionales(), formularioUCRIndex.getArticulosEvaInternos(), formularioUCRIndex.getArticulosEvaExternos(), formularioUCRIndex.getDiversidadIdioma(), formularioUCRIndex.getDocumentosNacionales(), formularioUCRIndex.getDocumentosInternacionales(), formularioUCRIndex.getRigurosos(), formularioUCRIndex.getMedianos(), formularioUCRIndex.getPoco(), formularioUCRIndex.getNoSelectivos(), formularioUCRIndex.getGuiaEvaluacion(), formularioUCRIndex.getListaEvaluadores());

                //insertar observacionesSolicitudUCRIndex
                con.insertarObservacionesSolicitudUCRIndex(revistaSolicitante.getIssn(), formularioUCRIndex.getObservacionSolicitudU1(), formularioUCRIndex.getObservacionSolicitudU2(), formularioUCRIndex.getObservacionSolicitudU3(), formularioUCRIndex.getObservacionSolicitudU4(), formularioUCRIndex.getObservacionSolicitudU5(), formularioUCRIndex.getObservacionSolicitudU6(), formularioUCRIndex.getObservacionSolicitudU7(), formularioUCRIndex.getObservacionSolicitudU8(), formularioUCRIndex.getObservacionSolicitudU9(), formularioUCRIndex.getObservacionSolicitudU10(), formularioUCRIndex.getObservacionSolicitudU11());
                //Enviar correo
                con.enviarCorreoNotificacion(revistaSolicitante.getNombre(), revistaSolicitante.getSolicitante(), revistaSolicitante.getCorreo(), revistaSolicitante.getFechaSolicitud());

            %>
            <h2>¡Muchas gracias! Su solicitud se recibió exitosamente</h2> 
        </div>
        <input type="submit" value="Volver a Inicio" onclick="window.location = 'index.jsp';" />
    </body>
</html>
