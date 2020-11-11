<%-- 
    Document   : evaPresentacion
    Created on : 28/04/2020, 03:13:42 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.presentacionEvaluados"%>
<%@page import="ucrindex.basicosEvaluados"%>

<%

    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    basicosEvaluados basicosRecuperados = (basicosEvaluados) misession.getAttribute("basicosRecuperados");
        
    if(request.getParameter("checkCriterio1") != null){
        basicosRecuperados.setResponsables("Sí cumple");
    }
    else
    {
        basicosRecuperados.setResponsables("No cumple");
    }
    
    if(request.getParameter("checkCriterio2") != null){
        basicosRecuperados.setGeneracionContinua("Sí cumple");
    }
    else
    {
        basicosRecuperados.setGeneracionContinua("No cumple");
    }
    
    if(request.getParameter("checkCriterio3") != null){
        basicosRecuperados.setIdAutores("Sí cumple");
    }
    else
    {
        basicosRecuperados.setIdAutores("No cumple");
    }
    
    if(request.getParameter("checkCriterio4") != null){
        basicosRecuperados.setEntidadEditora("Sí cumple");
    }
    else
    {
        basicosRecuperados.setEntidadEditora("No cumple");
    }
    
    if(request.getParameter("checkCriterio5") != null){
        basicosRecuperados.setInstruccionesAutores("Sí cumple");
    }
    else
    {
        basicosRecuperados.setInstruccionesAutores("No cumple");
    }
    
    if(request.getParameter("checkCriterio6") != null){
        basicosRecuperados.setSistemaArbitraje("Sí cumple");
    }
    else
    {
        basicosRecuperados.setSistemaArbitraje("No cumple");
    }

    if(request.getParameter("checkCriterio7") != null){
        basicosRecuperados.setIssnCriterio("Sí cumple");
    }
    else
    {
        basicosRecuperados.setIssnCriterio("No cumple");
    }

    basicosRecuperados.setObservacion1(request.getParameter("observacionEva1"));
    basicosRecuperados.setObservacion2(request.getParameter("observacionEva2"));
    basicosRecuperados.setObservacion3(request.getParameter("observacionEva3"));
    basicosRecuperados.setObservacion4(request.getParameter("observacionEva4"));
    basicosRecuperados.setObservacion5(request.getParameter("observacionEva5"));
    basicosRecuperados.setObservacion6(request.getParameter("observacionEva6"));
    basicosRecuperados.setObservacion7(request.getParameter("observacionEva7"));

    misession.setAttribute("basicosRecuperados", basicosRecuperados);

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

        public presentacionEvaluados solicitaPrePresentacion(String nombreRevista, String organismo) {

            presentacionEvaluados presentacionEnSolicitud = new presentacionEvaluados();

            String consultaSql = "Select criteriospresentacion.navegacion, criteriospresentacion.accesoHistorico, criteriospresentacion.mencionPeriodicidad,"
                    + " criteriospresentacion.membreteInicio, criteriospresentacion.afiliacionCuerposEditoriales, criteriospresentacion.afiliacionAutores, criteriospresentacion.fechasRecepcionAceptacion,"
                    + " observacionessolicitudlatindex.observacion8, observacionessolicitudlatindex.observacion9, observacionessolicitudlatindex.observacion10, observacionessolicitudlatindex.observacion11,"
                    + " observacionessolicitudlatindex.observacion12, observacionessolicitudlatindex.observacion13, observacionessolicitudlatindex.observacion14"
                    + " FROM datosrevista, criteriospresentacion, observacionessolicitudlatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriospresentacion.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    presentacionEnSolicitud.setNavegacion(resultado.getBoolean(1));
                    presentacionEnSolicitud.setAccesoHistorico(resultado.getBoolean(2));
                    presentacionEnSolicitud.setMencionPeriodicidad(resultado.getString(3));
                    presentacionEnSolicitud.setMembreteInicio(resultado.getBoolean(4));
                    presentacionEnSolicitud.setAfiliacionCuerposEditoriales(resultado.getString(5));
                    presentacionEnSolicitud.setAfiliacionAutores(resultado.getBoolean(6));
                    presentacionEnSolicitud.setFechasRecepcionAceptacion(resultado.getBoolean(7));

                    presentacionEnSolicitud.setObservacion8(resultado.getString(8));
                    presentacionEnSolicitud.setObservacion9(resultado.getString(9));
                    presentacionEnSolicitud.setObservacion10(resultado.getString(10));
                    presentacionEnSolicitud.setObservacion11(resultado.getString(11));
                    presentacionEnSolicitud.setObservacion12(resultado.getString(12));
                    presentacionEnSolicitud.setObservacion13(resultado.getString(13));
                    presentacionEnSolicitud.setObservacion14(resultado.getString(14));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return presentacionEnSolicitud;
        }
    }


%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluar</title>
    </head>
    <body>

        <%
            request.setCharacterEncoding("UTF-8");
            conexionBD con = new conexionBD();
            revistaEvaluada revistaRecuperada = (revistaEvaluada) misession.getAttribute("revistaRecuperada");
            revistaRecuperada.setFasciculo(request.getParameter("textFasciculoEvaluado"));
            presentacionEvaluados presentacionRecuperados = con.solicitaPrePresentacion(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("presentacionRecuperados", presentacionRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="evaluacion" action="evaGestion.jsp" method="POST">
            <h3>Criterios de Presentación</h3>
            <table border="1">
                <thead>
                    <tr>
                        <th>Criterio</th>
                        <th>Respuesta del Solicitante</th>
                        <th>Observación Pre-Evaluación</th>
                        <th>¿Cumple?</th>
                        <th>Observación del Evaluador</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>8. Navegación y funcionalidad en el acceso a contenidos</td>
                        <%if (presentacionRecuperados.getNavegacion()) {%>
                        <td><textarea name="preCriterio8" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio8" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio8" rows="3" cols="30"><%=presentacionRecuperados.getObservacion8()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio8" value="ON" /></td>
                        <td><textarea name="observacionEva8" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>9. Acceso histórico al contenido</td>
                        <%if (presentacionRecuperados.getAccesoHistorico()) {%>
                        <td><textarea name="preCriterio9" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio9" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio9" rows="3" cols="30"><%=presentacionRecuperados.getObservacion9()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio9" value="ON" /></td>
                        <td><textarea name="observacionEva9" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>10. Mención de periodicidad </td>
                        <td><textarea name="preCriterio10" rows="3" cols="30"/><%=presentacionRecuperados.getMencionPeriodicidad()%></textarea></td>
                        <td><textarea name="preObCriterio10" rows="3" cols="30"><%=presentacionRecuperados.getObservacion10()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio10" value="ON" /></td>
                        <td><textarea name="observacionEva10" rows="3" cols="30"></textarea></td>

                    </tr>
                    <tr>
                        <td>11. Membrete bibliográfico al inicio del artículo</td>
                        <%if (presentacionRecuperados.getMembreteInicio()) {%>
                        <td><textarea name="preCriterio11" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio11" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio11" rows="3" cols="30"><%=presentacionRecuperados.getObservacion11()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio11" value="ON" /></td>
                        <td><textarea name="observacionEva11" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>12. Afiliación institucional de los miembros de los cuerpos editoriales</td>
                        <td><textarea name="preCriterio12" rows="3" cols="30"/><%=presentacionRecuperados.getAfiliacionCuerposEditoriales()%></textarea></td>
                        <td><textarea name="preObCriterio12" rows="3" cols="30"><%=presentacionRecuperados.getObservacion12()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio12" value="ON" /></td>
                        <td><textarea name="observacionEva12" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>13. Afiliación de los autores </td>
                        <%if (presentacionRecuperados.getAfiliacionAutores()) {%>
                        <td><textarea name="preCriterio13" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio13" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio13" rows="3" cols="30"><%=presentacionRecuperados.getObservacion13()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio13" value="ON" /></td>
                        <td><textarea name="observacionEva13" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td> 14. Fechas de recepción y aceptación de originales</td>
                        <%if (presentacionRecuperados.getFechasRecepcionAceptacion()) {%>
                        <td><textarea name="preCriterio14" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio14" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio14" rows="3" cols="30"><%=presentacionRecuperados.getObservacion14()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio14" value="ON" /></td>
                        <td><textarea name="observacionEva14" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>

            <br>
            <div id="botonSiguiente">
                <button type="button" name="back" onclick="history.back()">ATRÁS</button>
                <input type="submit" value="SIGUIENTE" name="enviarPresentacion"/>
            </div>      
        </form>
    </body>
</html>
