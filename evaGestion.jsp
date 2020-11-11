<%-- 
    Document   : evaGestion
    Created on : 29/04/2020, 08:26:30 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.gestionEvaluados"%>
<%@page import="ucrindex.presentacionEvaluados"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    presentacionEvaluados presentacionRecuperados = (presentacionEvaluados) misession.getAttribute("presentacionRecuperados");
    
    presentacionRecuperados.setNavegacion(request.getParameter("checkCriterio8") != null);
    presentacionRecuperados.setAccesoHistorico(request.getParameter("checkCriterio9") != null);
    
    if(request.getParameter("checkCriterio10") != null){
        presentacionRecuperados.setMencionPeriodicidad("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setMencionPeriodicidad("No cumple");
    }
     
    presentacionRecuperados.setMembreteInicio(request.getParameter("checkCriterio11") != null);
    
    if(request.getParameter("checkCriterio12") != null){
        presentacionRecuperados.setAfiliacionCuerposEditoriales("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setAfiliacionCuerposEditoriales("No cumple");
    }
    
    
    presentacionRecuperados.setAfiliacionAutores(request.getParameter("checkCriterio13") != null);
    presentacionRecuperados.setFechasRecepcionAceptacion(request.getParameter("checkCriterio14") != null);
    
    presentacionRecuperados.setObservacion8(request.getParameter("observacionEva8"));
    presentacionRecuperados.setObservacion9(request.getParameter("observacionEva9"));
    presentacionRecuperados.setObservacion10(request.getParameter("observacionEva10"));
    presentacionRecuperados.setObservacion11(request.getParameter("observacionEva11"));
    presentacionRecuperados.setObservacion12(request.getParameter("observacionEva12"));
    presentacionRecuperados.setObservacion13(request.getParameter("observacionEva13"));
    presentacionRecuperados.setObservacion14(request.getParameter("observacionEva14"));
    
    misession.setAttribute("presentacionRecuperados", presentacionRecuperados);
    
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

        public gestionEvaluados solicitaPreGestion(String nombreRevista, String organismo) {

            gestionEvaluados gestionEnSolicitud = new gestionEvaluados();

            String consultaSql = "Select criteriosgestion.definicionRevista, criteriosgestion.autoresExternos, criteriosgestion.autoresInternos,"
                    + " criteriosgestion.miembrosInternos, criteriosgestion.miembrosExternos, criteriosgestion.serviciosInformacion, criteriosgestion.cumplimientoPeriodicidad,"
                    + " criteriosgestion.politicaAccesoReuso, criteriosgestion.codigoEtica, criteriosgestion.deteccionPlagio,"
                    + " observacionessolicitudlatindex.observacion15, observacionessolicitudlatindex.observacion16, observacionessolicitudlatindex.observacion17, observacionessolicitudlatindex.observacion18,"
                    + " observacionessolicitudlatindex.observacion19, observacionessolicitudlatindex.observacion20, observacionessolicitudlatindex.observacion21, observacionessolicitudlatindex.observacion22"
                    + " FROM datosrevista, criteriosgestion, observacionessolicitudlatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriosgestion.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    gestionEnSolicitud.setDefinicionRevista(resultado.getString(1));
                    gestionEnSolicitud.setAutoresExternos(resultado.getInt(2));
                    gestionEnSolicitud.setAutoresInternos(resultado.getInt(3));
                    gestionEnSolicitud.setMiembrosInternos(resultado.getInt(4));
                    gestionEnSolicitud.setMiembrosExternos(resultado.getInt(5));
                    gestionEnSolicitud.setServiciosInformacion(resultado.getString(6));
                    gestionEnSolicitud.setCumplimientoPeriodicidad(resultado.getString(7));
                    gestionEnSolicitud.setPoliticaAccesoReuso(resultado.getString(8));
                    gestionEnSolicitud.setCodigoEtica(resultado.getString(9));
                    gestionEnSolicitud.setDeteccionPlagio(resultado.getString(10));

                    gestionEnSolicitud.setObservacion15(resultado.getString(11));
                    gestionEnSolicitud.setObservacion16(resultado.getString(12));
                    gestionEnSolicitud.setObservacion17(resultado.getString(13));
                    gestionEnSolicitud.setObservacion18(resultado.getString(14));
                    gestionEnSolicitud.setObservacion19(resultado.getString(15));
                    gestionEnSolicitud.setObservacion20(resultado.getString(16));
                    gestionEnSolicitud.setObservacion21(resultado.getString(17));
                    gestionEnSolicitud.setObservacion22(resultado.getString(18));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return gestionEnSolicitud;
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
            gestionEvaluados gestionRecuperados = con.solicitaPreGestion(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("gestionRecuperados", gestionRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="evaluacion" action="evaContenido.jsp" method="POST">
            <h3>Criterios de Gestión y Política Editorial</h3>
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
                        <td>15. Definición de la revista</td>
                        <td><textarea name="preCriterio15" rows="3" cols="30"/><%=gestionRecuperados.getDefinicionRevista()%></textarea></td>
                        <td><textarea name="preObCriterio15" rows="3" cols="30"><%=gestionRecuperados.getObservacion15()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio15" value="ON" /></td>
                        <td><textarea name="observacionEva15" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>16. Autores externos</td>
                        <td><textarea name="preCriterio16" rows="3" cols="30"/>
                            Autores Internos: <%=gestionRecuperados.getAutoresInternos()%>
                            Autores Externos:  <%=gestionRecuperados.getAutoresExternos()%>
                            </textarea></td>
                        <td><textarea name="preObCriterio16" rows="3" cols="30"><%=gestionRecuperados.getObservacion16()%></textarea></td>
                        <td>
                            <label for="articulosAutoresInternos">Cantidad de documentos con autores internos:</label>
                            <input type="number" id="articulosAutoresInternos" name="articulosAutoresInternos" min="0" max="99" value="0">
                            <br><br>
                            <label for="articulosAutoresExternos">Cantidad de documentos con autores externos:</label>
                            <input type="number" id="articulosAutoresExternos" name="articulosAutoresExternos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEva16" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>17. Apertura editorial</td>
                        <td><textarea name="preCriterio17" rows="3" cols="30"/>
                            Miembros Internos: <%=gestionRecuperados.getMiembrosInternos()%>
                            Miembros Externos:  <%=gestionRecuperados.getMiembrosExternos()%>
                            </textarea></td>
                        <td><textarea name="preObCriterio17" rows="3" cols="30"><%=gestionRecuperados.getObservacion17()%></textarea></td>
                        <td>
                            <label for="miembrosInternos">Cantidad de miembros internos:</label>
                            <input type="number" id="miembrosInternos" name="miembrosInternos" min="0" max="99" value="0">
                            <br><br>
                            <label for="miembrosExternos">Cantidad de miembros externos:</label>
                            <input type="number" id="miembrosExternos" name="miembrosExternos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEva17" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>18. Servicios de información</td>
                        <td><textarea name="preCriterio18" rows="3" cols="30"/><%=gestionRecuperados.getServiciosInformacion()%></textarea></td>
                        <td><textarea name="preObCriterio18" rows="3" cols="30"><%=gestionRecuperados.getObservacion18()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio18" value="ON" /></td>
                        <td><textarea name="observacionEva18" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>19. Cumplimiento de periodicidad</td>
                        <td><textarea name="preCriterio19" rows="3" cols="30"/>
                            Fecha de publicación del último número: <%=gestionRecuperados.getCumplimientoPeriodicidad()%></textarea></td>
                        <td><textarea name="preObCriterio19" rows="3" cols="30"><%=gestionRecuperados.getObservacion19()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio19" value="ON" /></td>
                        <td><textarea name="observacionEva19" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>20. Políticas de acceso y reuso</td>
                        <td><textarea name="preCriterio20" rows="3" cols="30"/><%=gestionRecuperados.getPoliticaAccesoReuso()%></textarea></td>
                        <td><textarea name="preObCriterio20" rows="3" cols="30"><%=gestionRecuperados.getObservacion20()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio20" value="ON" /></td>
                        <td><textarea name="observacionEva20" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>21. Adopción de códigos de ética</td>
                        <td><textarea name="preCriterio21" rows="3" cols="30"/><%=gestionRecuperados.getCodigoEtica()%></textarea></td>
                        <td><textarea name="preObCriterio21" rows="3" cols="30"><%=gestionRecuperados.getObservacion21()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio21" value="ON" /></td>
                        <td><textarea name="observacionEva21" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>22. Detección de plagio</td>
                        <td><textarea name="preCriterio22" rows="3" cols="30"/><%=gestionRecuperados.getDeteccionPlagio()%></textarea></td>
                        <td><textarea name="preObCriterio22" rows="3" cols="30"><%=gestionRecuperados.getObservacion22()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio22" value="ON" /></td>
                        <td><textarea name="observacionEva22" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>

            <br>
            <div id="botonSiguiente">
                <button type="button" name="back" onclick="history.back()">ATRÁS</button>
                <input type="submit" value="SIGUIENTE" name="enviarGestion"/>
            </div>      
        </form>
    </body>
</html>
