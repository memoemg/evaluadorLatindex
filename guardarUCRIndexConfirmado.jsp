<%-- 
    Document   : guardarUCRIndexConfirmado
    Created on : 05/09/2020, 05:38:26 PM
    Author     : guies
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.ucrindexConfirmado"%>
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

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);

%>


<% Class.forName("com.mysql.jdbc.Driver");

    double notaUCRIndex = (Double.parseDouble(request.getParameter("notaUCRIndex")));

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

        public void enviarCorreoEvaUCRIndex(revistaConfirmada revista, ucrindexConfirmado ucrindex, ArrayList<String> criteriosLatindex, double notaUCRIndex) {

            String para = revista.getCorreo();
            //String para = "guillermo.murillogoussen@ucr.ac.cr";
            String desde = "REVISTAS@ucr.ac.cr";
            String asunto = "Resultado de Evaluación UCRIndex";

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
                msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse("jorgelpolanco@gmail.com", false));

                msg.setSubject(asunto);


                String textDiversidadIdioma = "No cumple";
                if(ucrindex.getDiversidadIdiomaEva())
                {
                    textDiversidadIdioma = "Sí cumple";
                }

                String text = "Estimado(a) "+revista.getResponsable()+" a continuación el resultado de la Evaluación UCRIndex de su revista";
                text += "\nRevista: " + revista.getNombre();

                text += "\n\nCRITERIOS UCRINDEX";
                text += "\nCantidad de artículos publicados: " + ucrindex.getNumeroArticulosEva() + " (de 15 requeridos)";
                text += "\nObservación: " + ucrindex.getObservacionEvaU0();
                text += "\nMención de los meses de publicación: " + ucrindex.getMencionMesesPublicacionEva();
                text += "\nObservación: " + ucrindex.getObservacionEvaU1();
                text += "\nCantidad de miembros editoriales nacionales: " + ucrindex.getMiembrosNacionalesEva();
                text += "\nCantidad de miembros editoriales internacionales: " + ucrindex.getMiembrosInternacionalesEva();
                text += "\nPorcentaje: " + ((double) ucrindex.getMiembrosInternacionalesEva() * 100.0000) / ((double) ucrindex.getMiembrosInternacionalesEva() + (double) ucrindex.getMiembrosNacionalesEva());
                text += "\nObservación: " + ucrindex.getObservacionEvaU2();
                text += "\n--De la totalidad de miembros del Cuerpo Editorial, un 66.7% debe ser internacional--";
                text += "\n\nDocumentos con evaluadores internos: " + ucrindex.getArticulosEvaInternosEva();
                text += "\nDocumentos con evaluadores externos: " + ucrindex.getArticulosEvaExternosEva();
                text += "\nPorcentaje: " + ((double) ucrindex.getArticulosEvaExternosEva() * 100.0000) / ((double) ucrindex.getArticulosEvaExternosEva()+ (double) ucrindex.getArticulosEvaInternosEva());
                text += "\nObservación: " + ucrindex.getObservacionEvaU3();
                text += "\n--El 80% de los artículos publicados debe tener evaluadores externos--";
                text += "\n\nDiversidad del idioma: " + textDiversidadIdioma;
                text += "\nObservación: " + ucrindex.getObservacionEvaU4();
                text += "\nAutores nacionales: " + ucrindex.getDocumentosNacionalesEva();
                text += "\nAutores internacionales: " + ucrindex.getDocumentosInternacionalesEva();
                text += "\nPorcentaje: " + ((double) ucrindex.getDocumentosInternacionalesEva()* 100.0000) / ((double) ucrindex.getDocumentosInternacionalesEva() + (double) ucrindex.getDocumentosNacionalesEva());
                text += "\nObservación: " + ucrindex.getObservacionEvaU5();
                text += "\n--Un 50% de los documentos publicados deben corresponder a autores extranjeros--";
                text += "\n\nÍndices rigurosos: " + ucrindex.getRigurososEva() + " (de 2 requeridos)";
                text += "\nObservación: " + ucrindex.getObservacionEvaU6();
                text += "\nÍndices medianamente rigurosos: " + ucrindex.getMedianosEva() + " (de 3 requeridos)";
                text += "\nObservación: " + ucrindex.getObservacionEvaU7();
                text += "\nÍndices poco rigurosos: " + ucrindex.getPocoEva() + " (de 4 requeridos)";
                text += "\nObservación: " + ucrindex.getObservacionEvaU8();
                text += "\nÍndices no selectivos: " + ucrindex.getNoSelectivosEva() + " (de 3 requeridos)";
                text += "\nObservación: " + ucrindex.getObservacionEvaU9();
                
                if(ucrindex.getGuiaEvaluacionEva())
                {
                    text += "\nGuía del evaluador: Sí cumple";
                }
                else
                {
                    text += "\nGuía del evaluador: No cumple";
                }
                text += "\nObservación: " + ucrindex.getObservacionEvaU10();

                if(ucrindex.getListaEvaluadoresEva())
                {
                    text += "\nLista de evaluadores: Sí cumple";
                }
                else
                {
                    text += "\nLista de evaluadores: No cumple";
                }
                text += "\nObservación: " + ucrindex.getObservacionEvaU11();

                text += "\nProcedimiento para la evaluación: " + criteriosLatindex.get(0);
                text += "\nUso de norma para las citas y referencias: " + criteriosLatindex.get(1);
                text += "\nExigencia de originalidad: " + criteriosLatindex.get(2);
                text += "\nCumplimiento de la periodicidad: " + criteriosLatindex.get(3);
                text += "\nCódigo ético: " + criteriosLatindex.get(4);
                text += "\nSistema de detección de plagio: " + criteriosLatindex.get(5);

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
                        System.out.println("Respuesta al envío de confirmación UCRIndex: " + t.getLastServerResponse());
                    }
                    t.close();
                }

                /*String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/Resultado-UCRIndex-" + revista.getNombre() + ".txt";
                PrintWriter pw = new PrintWriter(new FileOutputStream(nameOfTextFile));
                pw.println(text);
                clean up
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

        public ArrayList<String> solicitarCriteriosLatindex(String issnRevista) {
            String deteccionPlagio = ""; //gestion
            String codigoEtica = ""; //gestion
            String cumplimientoPeriodicidad = ""; //gestion
            String exigenciaOriginalidad = ""; //contenido
            String referenciasBibliograficas = ""; //contenido
            String procedimientoEvaluacion = ""; //basicos

            ArrayList<String> criteriosLatindex = new ArrayList<>();

            String consultaSql = "";

            consultaSql = "SELECT `sistemaArbitraje`, `referenciasBibliograficas`, `exigenciaOriginalidad`, `cumplimientoPeriodicidad`, `codigoEtica`,"
            + " `deteccionPlagio` FROM confirmagestion, confirmabasicos, confirmacontenido WHERE confirmagestion.issnRevista = '"+issnRevista+"' AND confirmacontenido.issnRevista = confirmagestion.issnRevista AND confirmabasicos.issnRevista = confirmagestion.issnRevista;";
            System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    procedimientoEvaluacion = resultado.getString(1);
                    referenciasBibliograficas = resultado.getString(2);
                    exigenciaOriginalidad = resultado.getString(3);
                    cumplimientoPeriodicidad = resultado.getString(4);
                    codigoEtica = resultado.getString(5);
                    deteccionPlagio = resultado.getString(6);
                }

                criteriosLatindex.add(procedimientoEvaluacion);
                criteriosLatindex.add(referenciasBibliograficas);
                criteriosLatindex.add(exigenciaOriginalidad);
                criteriosLatindex.add(cumplimientoPeriodicidad);
                criteriosLatindex.add(codigoEtica);
                criteriosLatindex.add(deteccionPlagio);

            } catch (SQLException e) {
                System.out.println("Entré en el catch de criteriosLatindex");
            }

            return criteriosLatindex;

        }

        public int actualizarNotaUCRIndex(String issnRevista, double notaUCRIndex) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `notas` SET `notaUcrindex` = " + notaUCRIndex + " WHERE issnRevista = '" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarConfirmacionUCRIndex(String issnRevista, int numeroArticulos, String mencionMesesPublicacion, int miembrosNacionales, int miembrosInternacionales, int articulosEvaInternos, int articulosEvaExternos, boolean diversidadIdioma, int documentosNacionales, int documentosInternacionales, int rigurosos, int medianos, int poco, int noSelectivos, boolean guiaEvaluacion, boolean listaEvaluadores) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `confirmaucrindex`(`issnRevista`, `numeroArticulos`, `mencionMeses`, `miembrosNacionales`, `miembrosInternacionales`, `articulosEvaInternos`, `articulosEvaExternos`, `diversidadIdioma`, `documentosNacionales`, `documentosInternacionales`, `rigurosos`, `medianos`, `poco`, `noSelectivos`, `guiaEvaluacion`, `listaEvaluadores`) VALUES ('" + issnRevista + "', " + numeroArticulos + ", '" + mencionMesesPublicacion + "', " + miembrosNacionales + ", " + miembrosInternacionales + ", " + articulosEvaInternos + ", " + articulosEvaExternos + ", " + diversidadIdioma + ", " + documentosNacionales + ", " + documentosInternacionales + ", " + rigurosos + ", " + medianos
                    + ", " + poco + ", " + noSelectivos + ", " + guiaEvaluacion + ", " + listaEvaluadores + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesConfirmaUCRIndex(String issnRevista, String observacion0, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionesconfirmaucrindex`(`issnrevista`, `observacionConfirma0`, `observacionConfirma1`, `observacionConfirma2`, `observacionConfirma3`, `observacionConfirma4`, `observacionConfirma5`, `observacionConfirma6`, `observacionConfirma7`, `observacionConfirma8`, `observacionConfirma9`, `observacionConfirma10`, `observacionConfirma11`)"
                    + " VALUES ('" + issnRevista + "', '" + observacion0 + "', '" + observacion1 + "', '" + observacion2 + "', '" + observacion3 + "', '" + observacion4 + "', '" + observacion5 + "', '" + observacion6 + "', '" + observacion7 + "', '" + observacion8 + "', '" + observacion9 + "', '" + observacion10
                    + "', '" + observacion11 + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int actualizarObservacionesEvaUCRIndex(String issnRevista, String observacion0, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `observacionesevaucrindex` SET `observacionEva0`='" + observacion0 + "', `observacionEva1`='" + observacion1 + "', `observacionEva2`='" + observacion2 + "', `observacionEva3`='" + observacion3 + "', `observacionEva4`='" + observacion4 + "', `observacionEva5`='" + observacion5 + "', `observacionEva6`='" + observacion6 + "', `observacionEva7`='" + observacion7 + "', `observacionEva8`='" + observacion8 + "', `observacionEva9`='" + observacion9 + "', `observacionEva10`='" + observacion10 + "', `observacionEva11`='" + observacion11 + "' WHERE issnRevista='" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
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
        <%            

            revistaConfirmada revistaRecuperada = (revistaConfirmada) misession.getAttribute("revistaRecuperada");
            ucrindexConfirmado ucrindexRecuperado = (ucrindexConfirmado) misession.getAttribute("ucrindexRecuperado");
            conexionBD con = new conexionBD();

            con.insertarConfirmacionUCRIndex(revistaRecuperada.getIssn(), ucrindexRecuperado.getNumeroArticulosEva(), ucrindexRecuperado.getMencionMesesPublicacionEva(), ucrindexRecuperado.getMiembrosNacionales(),
                    ucrindexRecuperado.getMiembrosInternacionalesEva(), ucrindexRecuperado.getArticulosEvaInternosEva(), ucrindexRecuperado.getArticulosEvaExternosEva(),
                    ucrindexRecuperado.getDiversidadIdiomaEva(), ucrindexRecuperado.getDocumentosNacionalesEva(), ucrindexRecuperado.getDocumentosInternacionalesEva(),
                    ucrindexRecuperado.getRigurososEva(), ucrindexRecuperado.getMedianosEva(), ucrindexRecuperado.getPocoEva(), ucrindexRecuperado.getNoSelectivosEva(),
                    ucrindexRecuperado.getGuiaEvaluacionEva(), ucrindexRecuperado.getListaEvaluadoresEva());

            con.actualizarNotaUCRIndex(revistaRecuperada.getIssn(), notaUCRIndex);

            //insertar observacionesPreevaluacion
            con.insertarObservacionesConfirmaUCRIndex(revistaRecuperada.getIssn(), ucrindexRecuperado.getObservacionSolicitudU0(), ucrindexRecuperado.getObservacionSolicitudU1(), ucrindexRecuperado.getObservacionSolicitudU2(),
                    ucrindexRecuperado.getObservacionSolicitudU3(), ucrindexRecuperado.getObservacionSolicitudU4(), ucrindexRecuperado.getObservacionSolicitudU5(), ucrindexRecuperado.getObservacionSolicitudU6(),
                    ucrindexRecuperado.getObservacionSolicitudU7(), ucrindexRecuperado.getObservacionSolicitudU8(), ucrindexRecuperado.getObservacionSolicitudU9(), ucrindexRecuperado.getObservacionSolicitudU10(), ucrindexRecuperado.getObservacionSolicitudU11());

            con.actualizarObservacionesEvaUCRIndex(revistaRecuperada.getIssn(), ucrindexRecuperado.getObservacionSolicitudU0(), ucrindexRecuperado.getObservacionSolicitudU1(), ucrindexRecuperado.getObservacionSolicitudU2(),
                    ucrindexRecuperado.getObservacionSolicitudU3(), ucrindexRecuperado.getObservacionSolicitudU4(), ucrindexRecuperado.getObservacionSolicitudU5(), ucrindexRecuperado.getObservacionSolicitudU6(),
                    ucrindexRecuperado.getObservacionSolicitudU7(), ucrindexRecuperado.getObservacionSolicitudU8(), ucrindexRecuperado.getObservacionSolicitudU9(), ucrindexRecuperado.getObservacionSolicitudU10(), ucrindexRecuperado.getObservacionSolicitudU11());

            con.enviarCorreoEvaUCRIndex(revistaRecuperada, ucrindexRecuperado, con.solicitarCriteriosLatindex(revistaRecuperada.getIssn()), notaUCRIndex);

            response.sendRedirect("tabla.jsp");


        %>

    </body>
</html>
