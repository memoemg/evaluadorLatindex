<%-- 
    Document   : calculoNotaUCRIndex
    Created on : 06/05/2020, 03:01:36 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.ucrindexEvaluado"%>


<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    ucrindexEvaluado ucrindexRecuperado = (ucrindexEvaluado) misession.getAttribute("ucrindexRecuperado");
    revistaEvaluada revistaRecuperada = (revistaEvaluada) misession.getAttribute("revistaRecuperada");
    
    ucrindexRecuperado.setNumeroArticulos(Integer.parseInt(request.getParameter("articulosPublicados")));

    if (request.getParameter("checkUcrindex1") != null) {
        ucrindexRecuperado.setMencionMesesPublicacion("Sí cumple");
    } else {
        ucrindexRecuperado.setMencionMesesPublicacion("No cumple");
    }

    ucrindexRecuperado.setMiembrosNacionales(Integer.parseInt(request.getParameter("miembrosNacionales")));
    ucrindexRecuperado.setMiembrosInternacionales(Integer.parseInt(request.getParameter("miembrosInternacionales")));
    ucrindexRecuperado.setArticulosEvaInternos(Integer.parseInt(request.getParameter("evaluadoresInternos")));
    ucrindexRecuperado.setArticulosEvaExternos(Integer.parseInt(request.getParameter("evaluadoresExternos")));

    ucrindexRecuperado.setDiversidadIdioma(request.getParameter("checkUcrindex4") != null);

    ucrindexRecuperado.setDocumentosNacionales(Integer.parseInt(request.getParameter("documentosNacionales")));
    ucrindexRecuperado.setDocumentosInternacionales(Integer.parseInt(request.getParameter("documentosInternacionales")));
    ucrindexRecuperado.setRigurosos(Integer.parseInt(request.getParameter("rigurosos")));
    ucrindexRecuperado.setMedianos(Integer.parseInt(request.getParameter("medianos")));
    ucrindexRecuperado.setPoco(Integer.parseInt(request.getParameter("poco")));
    ucrindexRecuperado.setNoSelectivos(Integer.parseInt(request.getParameter("noSelectivos")));

    ucrindexRecuperado.setGuiaEvaluacion(request.getParameter("checkUcrindex10") != null);
    ucrindexRecuperado.setListaEvaluadores(request.getParameter("checkUcrindex11") != null);
    
    ucrindexRecuperado.setObservacionSolicitudU0(request.getParameter("observacionEvaU0"));
    ucrindexRecuperado.setObservacionSolicitudU1(request.getParameter("observacionEvaU1"));
    ucrindexRecuperado.setObservacionSolicitudU2(request.getParameter("observacionEvaU2"));
    ucrindexRecuperado.setObservacionSolicitudU3(request.getParameter("observacionEvaU3"));
    ucrindexRecuperado.setObservacionSolicitudU4(request.getParameter("observacionEvaU4"));
    ucrindexRecuperado.setObservacionSolicitudU5(request.getParameter("observacionEvaU5"));
    ucrindexRecuperado.setObservacionSolicitudU6(request.getParameter("observacionEvaU6"));
    ucrindexRecuperado.setObservacionSolicitudU7(request.getParameter("observacionEvaU7"));
    ucrindexRecuperado.setObservacionSolicitudU8(request.getParameter("observacionEvaU8"));
    ucrindexRecuperado.setObservacionSolicitudU9(request.getParameter("observacionEvaU9"));
    ucrindexRecuperado.setObservacionSolicitudU10(request.getParameter("observacionEvaU10"));
    ucrindexRecuperado.setObservacionSolicitudU11(request.getParameter("observacionEvaU11"));

%>

<% Class.forName("com.mysql.jdbc.Driver");%>

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
        public boolean estaIndexada(String issn) {

            String consultaSql = "SELECT indexada FROM notas WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean indexada = false;

            try {
                while (resultado.next()) {
                    indexada = resultado.getBoolean(1);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return indexada;
        }

        public int obtenerNumArticulos(String issn) {

            String consultaSql = "SELECT cantidadArticulosAnho FROM evacontenido WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            int numArticulos = 0;

            try {
                while (resultado.next()) {
                    numArticulos = resultado.getInt(1);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return numArticulos;
        }

        public boolean cumplePeriodicidad(String issn) {

            String consultaSql = "SELECT cumplimientoPeriodicidad FROM evagestion WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumplePeriodicidad = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumplePeriodicidad = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumplePeriodicidad;
        }

        public boolean cumpleSistemaArbitraje(String issn) {

            String consultaSql = "SELECT sistemaArbitraje FROM evabasicos WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumpleSistemaArbitraje = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumpleSistemaArbitraje = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumpleSistemaArbitraje;
        }

        public boolean cumpleExigenciaOriginalidad(String issn) {

            String consultaSql = "SELECT exigenciaOriginalidad FROM evacontenido WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumpleExigenciaOriginalidad = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumpleExigenciaOriginalidad = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumpleExigenciaOriginalidad;
        }

        public boolean cumpleCodigoEtica(String issn) {

            String consultaSql = "SELECT codigoEtica FROM evagestion WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumpleCodigoEtica = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumpleCodigoEtica = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumpleCodigoEtica;
        }

        public boolean cumpleNormaReferencias(String issn) {

            String consultaSql = "SELECT referenciasBibliograficas FROM evacontenido WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumpleNorma = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumpleNorma = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumpleNorma;
        }

        public boolean cumpleDeteccionPlagio(String issn) {

            String consultaSql = "SELECT deteccionPlagio FROM evagestion WHERE issnRevista = '" + issn + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);
            boolean cumplePlagio = false;

            try {
                while (resultado.next()) {
                    String enLaBase = resultado.getString(1);
                    cumplePlagio = enLaBase.equals("Sí cumple");
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return cumplePlagio;
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <body>
        <h1>Resultado UCRIndex</h1>

        <%
            conexionBD con = new conexionBD();
            //ucrindexRecuperado.setNotaGestion(con.obtenerNumArticulos(revistaRecuperada.getIssn()), con.cumplePeriodicidad(revistaRecuperada.getIssn()));
            ucrindexRecuperado.setNotaGestion(ucrindexRecuperado.getNumeroArticulos(), con.cumplePeriodicidad(revistaRecuperada.getIssn()));
            ucrindexRecuperado.setNotaVisibilidad();
            ucrindexRecuperado.setNotaContenido(con.cumpleSistemaArbitraje(revistaRecuperada.getIssn()), con.cumpleExigenciaOriginalidad(revistaRecuperada.getIssn()),
                    con.cumpleCodigoEtica(revistaRecuperada.getIssn()), con.cumpleDeteccionPlagio(revistaRecuperada.getIssn()), con.cumpleNormaReferencias(revistaRecuperada.getIssn()));
            double notaUCRIndex = ucrindexRecuperado.calcularNota(revistaRecuperada.getIssn(), con.estaIndexada(revistaRecuperada.getIssn()));
            
            misession.setAttribute("ucrindexRecuperado", ucrindexRecuperado);
        %>

        <form name="notaUCRIndex" action="guardarUCRIndex.jsp" method="POST">
                       
            <h4>Nota contenido: <%=ucrindexRecuperado.getNotaContenido()%></h4>
            <h4>Nota gestión: <%=ucrindexRecuperado.getNotaGestion()%></h4>
            <h4>Nota visibilidad: <%=ucrindexRecuperado.getNotaVisibilidad()%></h4>
            <h4>UCRÍndex: <%=notaUCRIndex%></h4>.

            <input type="hidden" id="notaUCRIndex" name="notaUCRIndex" value="<%=notaUCRIndex%>" />
            <input type="submit" value="Volver" onclick="history.back()" />
            <input type="submit" value="Guardar UCRIndex" name="guardarUCRIndex" />
        </form>

    </body>
</html>
