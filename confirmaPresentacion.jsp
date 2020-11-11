<%-- 
    Document   : confirmaPresentacion
    Created on : 08/08/2020, 12:14:26 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.presentacionConfirmados"%>
<%@page import="ucrindex.basicosConfirmados"%>

<%

    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    basicosConfirmados basicosRecuperados = (basicosConfirmados) misession.getAttribute("basicosRecuperados");

    if (request.getParameter("checkConfirmaCriterio1") != null) {
        basicosRecuperados.setResponsablesEva("Sí cumple");
    } else {
        basicosRecuperados.setResponsablesEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio2") != null) {
        basicosRecuperados.setGeneracionContinuaEva("Sí cumple");
    } else {
        basicosRecuperados.setGeneracionContinuaEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio3") != null) {
        basicosRecuperados.setIdAutoresEva("Sí cumple");
    } else {
        basicosRecuperados.setIdAutoresEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio4") != null) {
        basicosRecuperados.setEntidadEditoraEva("Sí cumple");
    } else {
        basicosRecuperados.setEntidadEditoraEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio5") != null) {
        basicosRecuperados.setInstruccionesAutoresEva("Sí cumple");
    } else {
        basicosRecuperados.setInstruccionesAutoresEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio6") != null) {
        basicosRecuperados.setSistemaArbitrajeEva("Sí cumple");
    } else {
        basicosRecuperados.setSistemaArbitrajeEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio7") != null) {
        basicosRecuperados.setIssnCriterioEva("Sí cumple");
    } else {
        basicosRecuperados.setIssnCriterioEva("No cumple");
    }

    basicosRecuperados.setObservacion1eva(request.getParameter("observacionEva1"));
    basicosRecuperados.setObservacion2eva(request.getParameter("observacionEva2"));
    basicosRecuperados.setObservacion3eva(request.getParameter("observacionEva3"));
    basicosRecuperados.setObservacion4eva(request.getParameter("observacionEva4"));
    basicosRecuperados.setObservacion5eva(request.getParameter("observacionEva5"));
    basicosRecuperados.setObservacion6eva(request.getParameter("observacionEva6"));
    basicosRecuperados.setObservacion7eva(request.getParameter("observacionEva7"));
    
    basicosRecuperados.setObservacion1confirma(request.getParameter("observacionConfirma1"));
    basicosRecuperados.setObservacion2confirma(request.getParameter("observacionConfirma2"));
    basicosRecuperados.setObservacion3confirma(request.getParameter("observacionConfirma3"));
    basicosRecuperados.setObservacion4confirma(request.getParameter("observacionConfirma4"));
    basicosRecuperados.setObservacion5confirma(request.getParameter("observacionConfirma5"));
    basicosRecuperados.setObservacion6confirma(request.getParameter("observacionConfirma6"));
    basicosRecuperados.setObservacion7confirma(request.getParameter("observacionConfirma7"));

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

        public presentacionConfirmados solicitaEvaPresentacion(String nombreRevista, String organismo) {

            presentacionConfirmados presentacionEnSolicitud = new presentacionConfirmados();

            String consultaSql = "Select criteriospresentacion.navegacion, criteriospresentacion.accesoHistorico, criteriospresentacion.mencionPeriodicidad,"
                    + " criteriospresentacion.membreteInicio, criteriospresentacion.afiliacionCuerposEditoriales, criteriospresentacion.afiliacionAutores, criteriospresentacion.fechasRecepcionAceptacion,"
                    + " evapresentacion.navegacion, evapresentacion.accesoHistorico, evapresentacion.mencionPeriodicidad,"
                    + " evapresentacion.membreteInicio, evapresentacion.afiliacionCuerposEditoriales, evapresentacion.afiliacionAutores, evapresentacion.fechasRecepcionAceptacion,"
                    + " observacionessolicitudlatindex.observacion8, observacionessolicitudlatindex.observacion9, observacionessolicitudlatindex.observacion10, observacionessolicitudlatindex.observacion11,"
                    + " observacionessolicitudlatindex.observacion12, observacionessolicitudlatindex.observacion13, observacionessolicitudlatindex.observacion14,"
                    + " observacionesevalatindex.observacionEva8, observacionesevalatindex.observacionEva9, observacionesevalatindex.observacionEva10, observacionesevalatindex.observacionEva11,"
                    + " observacionesevalatindex.observacionEva12, observacionesevalatindex.observacionEva13, observacionesevalatindex.observacionEva14"
                    + " FROM datosrevista, criteriospresentacion, evapresentacion, observacionessolicitudlatindex, observacionesevalatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriospresentacion.issnRevista AND datosrevista.issn = evapresentacion.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista AND datosrevista.issn = observacionesevalatindex.issnRevista;";
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

                    presentacionEnSolicitud.setNavegacionEva(resultado.getString(8));
                    presentacionEnSolicitud.setAccesoHistoricoEva(resultado.getString(9));
                    presentacionEnSolicitud.setMencionPeriodicidadEva(resultado.getString(10));
                    presentacionEnSolicitud.setMembreteInicioEva(resultado.getString(11));
                    presentacionEnSolicitud.setAfiliacionCuerposEditorialesEva(resultado.getString(12));
                    presentacionEnSolicitud.setAfiliacionAutoresEva(resultado.getString(13));
                    presentacionEnSolicitud.setFechasRecepcionAceptacionEva(resultado.getString(14));

                    presentacionEnSolicitud.setObservacion8(resultado.getString(15));
                    presentacionEnSolicitud.setObservacion9(resultado.getString(16));
                    presentacionEnSolicitud.setObservacion10(resultado.getString(17));
                    presentacionEnSolicitud.setObservacion11(resultado.getString(18));
                    presentacionEnSolicitud.setObservacion12(resultado.getString(19));
                    presentacionEnSolicitud.setObservacion13(resultado.getString(20));
                    presentacionEnSolicitud.setObservacion14(resultado.getString(21));

                    presentacionEnSolicitud.setObservacion8eva(resultado.getString(22));
                    presentacionEnSolicitud.setObservacion9eva(resultado.getString(23));
                    presentacionEnSolicitud.setObservacion10eva(resultado.getString(24));
                    presentacionEnSolicitud.setObservacion11eva(resultado.getString(25));
                    presentacionEnSolicitud.setObservacion12eva(resultado.getString(26));
                    presentacionEnSolicitud.setObservacion13eva(resultado.getString(27));
                    presentacionEnSolicitud.setObservacion14eva(resultado.getString(28));
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
            revistaConfirmada revistaRecuperada = (revistaConfirmada) misession.getAttribute("revistaRecuperada");
            presentacionConfirmados presentacionRecuperados = con.solicitaEvaPresentacion(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("presentacionRecuperados", presentacionRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="confirmacion" action="confirmaGestion.jsp" method="POST">
            <h3>Criterios de Presentación</h3>
            <table border="1">
                <thead>
                    <tr>
                        <th>Criterio</th>
                        <th>Respuesta del Solicitante</th>
                        <th>Observación Pre-Evaluación</th>
                        <th>¿Cumple?</th>
                        <th>Observación del Evaluador</th>
                        <th>Observación del Confirmador</th>
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
                            <%if ((presentacionRecuperados.getNavegacionEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio8" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio8" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva8" rows="3" cols="30"><%=presentacionRecuperados.getObservacion8eva()%></textarea></td>
                        <td><textarea name="observacionConfirma8" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>9. Acceso histórico al contenido</td>
                        <%if (presentacionRecuperados.getAccesoHistorico()) {%>
                        <td><textarea name="preCriterio9" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio9" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio9" rows="3" cols="30"><%=presentacionRecuperados.getObservacion9()%></textarea></td>
                            <%if ((presentacionRecuperados.getAccesoHistoricoEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio9" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio9" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva9" rows="3" cols="30"><%=presentacionRecuperados.getObservacion9eva()%></textarea></td>
                        <td><textarea name="observacionConfirma9" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>10. Mención de periodicidad </td>
                        <td><textarea name="preCriterio10" rows="3" cols="30"/><%=presentacionRecuperados.getMencionPeriodicidad()%></textarea></td>
                        <td><textarea name="preObCriterio10" rows="3" cols="30"><%=presentacionRecuperados.getObservacion10()%></textarea></td>
                            <%if ((presentacionRecuperados.getMencionPeriodicidadEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio10" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio10" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva10" rows="3" cols="30"><%=presentacionRecuperados.getObservacion10eva()%></textarea></td>
                        <td><textarea name="observacionConfirma10" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>11. Membrete bibliográfico al inicio del artículo</td>
                        <%if (presentacionRecuperados.getMembreteInicio()) {%>
                        <td><textarea name="preCriterio11" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio11" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio11" rows="3" cols="30"><%=presentacionRecuperados.getObservacion11()%></textarea></td>
                            <%if ((presentacionRecuperados.getMembreteInicioEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio11" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio11" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva11" rows="3" cols="30"><%=presentacionRecuperados.getObservacion11eva()%></textarea></td>
                        <td><textarea name="observacionConfirma11" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>12. Afiliación institucional de los miembros de los cuerpos editoriales</td>
                        <td><textarea name="preCriterio12" rows="3" cols="30"/><%=presentacionRecuperados.getAfiliacionCuerposEditoriales()%></textarea></td>
                        <td><textarea name="preObCriterio12" rows="3" cols="30"><%=presentacionRecuperados.getObservacion12()%></textarea></td>
                            <%if ((presentacionRecuperados.getAfiliacionCuerposEditorialesEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio12" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio12" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva12" rows="3" cols="30"><%=presentacionRecuperados.getObservacion12eva()%></textarea></td>
                        <td><textarea name="observacionConfirma12" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>13. Afiliación de los autores </td>
                        <%if (presentacionRecuperados.getAfiliacionAutores()) {%>
                        <td><textarea name="preCriterio13" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio13" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio13" rows="3" cols="30"><%=presentacionRecuperados.getObservacion13()%></textarea></td>
                            <%if ((presentacionRecuperados.getAfiliacionAutoresEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio13" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio13" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva13" rows="3" cols="30"><%=presentacionRecuperados.getObservacion13eva()%></textarea></td>
                        <td><textarea name="observacionConfirma13" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td> 14. Fechas de recepción y aceptación de originales</td>
                        <%if (presentacionRecuperados.getFechasRecepcionAceptacion()) {%>
                        <td><textarea name="preCriterio14" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio14" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio14" rows="3" cols="30"><%=presentacionRecuperados.getObservacion14()%></textarea></td>
                            <%if ((presentacionRecuperados.getFechasRecepcionAceptacionEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio14" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio14" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva14" rows="3" cols="30"><%=presentacionRecuperados.getObservacion14eva()%></textarea></td>
                        <td><textarea name="observacionConfirma14" rows="3" cols="30"></textarea></td>
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
