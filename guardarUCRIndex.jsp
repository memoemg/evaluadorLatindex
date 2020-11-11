<%-- 
    Document   : guardarUCRIndex
    Created on : 08/05/2020, 09:55:46 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.ucrindexEvaluado"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"  %>
<%@page import="java.sql.*"%>


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

        public int insertarNotaUCRIndex(String issnRevista, double notaUCRIndex) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `notas` SET `notaUcrindex` = "+notaUCRIndex+" WHERE issnRevista = '" + issnRevista + "';";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaluacionUCRIndex(String issnRevista, int numeroArticulos, String mencionMesesPublicacion, int miembrosNacionales, int miembrosInternacionales, int articulosEvaInternos, int articulosEvaExternos, boolean diversidadIdioma, int documentosNacionales, int documentosInternacionales, int rigurosos, int medianos, int poco, int noSelectivos, boolean guiaEvaluacion, boolean listaEvaluadores) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evaucrindex`(`issnRevista`, `numeroArticulos`, `mencionMesesPublicacion`, `miembrosNacionales`, `miembrosInternacionales`, `articulosEvaInternos`, `articulosEvaExternos`, `diversidadIdioma`, `documentosNacionales`, `documentosInternacionales`, `rigurosos`, `medianos`, `poco`, `noSelectivos`, `guiaEvaluacion`, `listaEvaluadores`) VALUES ('" + issnRevista + "', " +numeroArticulos+", '" + mencionMesesPublicacion + "', " + miembrosNacionales + ", " + miembrosInternacionales + ", " + articulosEvaInternos + ", " + articulosEvaExternos + ", " + diversidadIdioma + ", " + documentosNacionales + ", " + documentosInternacionales + ", " + rigurosos + ", " + medianos
                    + ", " + poco + ", " + noSelectivos + ", " + guiaEvaluacion + ", " + listaEvaluadores + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesEvaUCRIndex(String issnRevista, String observacion0, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionesevaucrindex`(`issnrevista`, `observacionEva0`, `observacionEva1`, `observacionEva2`, `observacionEva3`, `observacionEva4`, `observacionEva5`, `observacionEva6`, `observacionEva7`, `observacionEva8`, `observacionEva9`, `observacionEva10`, `observacionEva11`)"
                + " VALUES ('" + issnRevista + "', '" + observacion0 + "', '" + observacion1 + "', '" + observacion2 + "', '" + observacion3 + "', '" + observacion4 + "', '" + observacion5 + "', '" + observacion6 + "', '" + observacion7 + "', '" + observacion8 + "', '" + observacion9 + "', '" + observacion10
                    + "', '" + observacion11 +"');";

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
            request.setCharacterEncoding("UTF-8");

            HttpSession misession = request.getSession(true);
            revistaEvaluada revistaRecuperada = (revistaEvaluada) misession.getAttribute("revistaRecuperada");
            ucrindexEvaluado ucrindexRecuperado = (ucrindexEvaluado) misession.getAttribute("ucrindexRecuperado");
            conexionBD con = new conexionBD();
            
            con.insertarEvaluacionUCRIndex(revistaRecuperada.getIssn(), ucrindexRecuperado.getNumeroArticulos(), ucrindexRecuperado.getMencionMesesPublicacion(), ucrindexRecuperado.getMiembrosNacionales(), 
                    ucrindexRecuperado.getMiembrosInternacionales(), ucrindexRecuperado.getArticulosEvaInternos(), ucrindexRecuperado.getArticulosEvaExternos(), 
                    ucrindexRecuperado.getDiversidadIdioma(), ucrindexRecuperado.getDocumentosNacionales(), ucrindexRecuperado.getDocumentosInternacionales(), 
                    ucrindexRecuperado.getRigurosos(), ucrindexRecuperado.getMedianos(), ucrindexRecuperado.getPoco(), ucrindexRecuperado.getNoSelectivos(), 
                    ucrindexRecuperado.getGuiaEvaluacion(), ucrindexRecuperado.getListaEvaluadores());
            
            con.insertarNotaUCRIndex(revistaRecuperada.getIssn(), notaUCRIndex);

            //insertar observacionesPreevaluacion
            con.insertarObservacionesEvaUCRIndex(revistaRecuperada.getIssn(), ucrindexRecuperado.getObservacionSolicitudU0(), ucrindexRecuperado.getObservacionSolicitudU1(), ucrindexRecuperado.getObservacionSolicitudU2(), 
                    ucrindexRecuperado.getObservacionSolicitudU3(), ucrindexRecuperado.getObservacionSolicitudU4(), ucrindexRecuperado.getObservacionSolicitudU5(), ucrindexRecuperado.getObservacionSolicitudU6(), 
                    ucrindexRecuperado.getObservacionSolicitudU7(), ucrindexRecuperado.getObservacionSolicitudU8(), ucrindexRecuperado.getObservacionSolicitudU9(), ucrindexRecuperado.getObservacionSolicitudU10(), ucrindexRecuperado.getObservacionSolicitudU11());
            

            response.sendRedirect("tabla.jsp");


        %>

    </body>
</html>
