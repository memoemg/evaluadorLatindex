<%-- 
    Document   : confirmaGestion
    Created on : 08/08/2020, 03:49:36 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.gestionConfirmados"%>
<%@page import="ucrindex.presentacionConfirmados"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    presentacionConfirmados presentacionRecuperados = (presentacionConfirmados) misession.getAttribute("presentacionRecuperados");
    
    if(request.getParameter("checkConfirmaCriterio8") != null){
        presentacionRecuperados.setNavegacionEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setNavegacionEva("No cumple");
    }
       
    if(request.getParameter("checkConfirmaCriterio9") != null){
        presentacionRecuperados.setAccesoHistoricoEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setAccesoHistoricoEva("No cumple");
    }
    
    if(request.getParameter("checkConfirmaCriterio10") != null){
        presentacionRecuperados.setMencionPeriodicidadEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setMencionPeriodicidadEva("No cumple");
    }
     
    if(request.getParameter("checkConfirmaCriterio11") != null){
        presentacionRecuperados.setMembreteInicioEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setMembreteInicioEva("No cumple");
    }
    
    
    if(request.getParameter("checkConfirmaCriterio12") != null){
        presentacionRecuperados.setAfiliacionCuerposEditorialesEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setAfiliacionCuerposEditorialesEva("No cumple");
    }
    
    if(request.getParameter("checkConfirmaCriterio13") != null){
        presentacionRecuperados.setAfiliacionAutoresEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setAfiliacionAutoresEva("No cumple");
    }
    
    if(request.getParameter("checkConfirmaCriterio14") != null){
        presentacionRecuperados.setFechasRecepcionAceptacionEva("Sí cumple");
    }
    else
    {
        presentacionRecuperados.setFechasRecepcionAceptacionEva("No cumple");
    }
    
    
    presentacionRecuperados.setObservacion8eva(request.getParameter("observacionEva8"));
    presentacionRecuperados.setObservacion9eva(request.getParameter("observacionEva9"));
    presentacionRecuperados.setObservacion10eva(request.getParameter("observacionEva10"));
    presentacionRecuperados.setObservacion11eva(request.getParameter("observacionEva11"));
    presentacionRecuperados.setObservacion12eva(request.getParameter("observacionEva12"));
    presentacionRecuperados.setObservacion13eva(request.getParameter("observacionEva13"));
    presentacionRecuperados.setObservacion14eva(request.getParameter("observacionEva14"));
    
    presentacionRecuperados.setObservacion8confirma(request.getParameter("observacionConfirma8"));
    presentacionRecuperados.setObservacion9confirma(request.getParameter("observacionConfirma9"));
    presentacionRecuperados.setObservacion10confirma(request.getParameter("observacionConfirma10"));
    presentacionRecuperados.setObservacion11confirma(request.getParameter("observacionConfirma11"));
    presentacionRecuperados.setObservacion12confirma(request.getParameter("observacionConfirma12"));
    presentacionRecuperados.setObservacion13confirma(request.getParameter("observacionConfirma13"));
    presentacionRecuperados.setObservacion14confirma(request.getParameter("observacionConfirma14"));
    
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

        public gestionConfirmados solicitaEvaGestion(String nombreRevista, String organismo) {

            gestionConfirmados gestionEnSolicitud = new gestionConfirmados();

            String consultaSql = "Select criteriosgestion.definicionRevista, criteriosgestion.autoresExternos, criteriosgestion.autoresInternos,"
                    + " criteriosgestion.miembrosInternos, criteriosgestion.miembrosExternos, criteriosgestion.serviciosInformacion, criteriosgestion.cumplimientoPeriodicidad,"
                    + " criteriosgestion.politicaAccesoReuso, criteriosgestion.codigoEtica, criteriosgestion.deteccionPlagio,"
                    + " evagestion.definicionRevista, evagestion.autoresExternos, evagestion.autoresInternos,"
                    + " evagestion.miembrosInternos, evagestion.miembrosExternos, evagestion.serviciosInformacion, evagestion.cumplimientoPeriodicidad,"
                    + " evagestion.politicaAccesoReuso, evagestion.codigoEtica, evagestion.deteccionPlagio,"
                    + " observacionessolicitudlatindex.observacion15, observacionessolicitudlatindex.observacion16, observacionessolicitudlatindex.observacion17, observacionessolicitudlatindex.observacion18,"
                    + " observacionessolicitudlatindex.observacion19, observacionessolicitudlatindex.observacion20, observacionessolicitudlatindex.observacion21, observacionessolicitudlatindex.observacion22,"
                    + " observacionesevalatindex.observacionEva15, observacionesevalatindex.observacionEva16, observacionesevalatindex.observacionEva17, observacionesevalatindex.observacionEva18,"
                    + " observacionesevalatindex.observacionEva19, observacionesevalatindex.observacionEva20, observacionesevalatindex.observacionEva21, observacionesevalatindex.observacionEva22"
                    + " FROM datosrevista, criteriosgestion, evagestion, observacionessolicitudlatindex, observacionesevalatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriosgestion.issnRevista AND datosrevista.issn = evagestion.issnRevista AND datosrevista.issn = observacionesevalatindex.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
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

                    gestionEnSolicitud.setDefinicionRevistaEva(resultado.getString(11));
                    gestionEnSolicitud.setAutoresExternosEva(resultado.getString(12));
                    gestionEnSolicitud.setAutoresInternosEva(resultado.getString(13));
                    gestionEnSolicitud.setMiembrosInternosEva(resultado.getString(14));
                    gestionEnSolicitud.setMiembrosExternosEva(resultado.getString(15));
                    gestionEnSolicitud.setServiciosInformacionEva(resultado.getString(16));
                    gestionEnSolicitud.setCumplimientoPeriodicidadEva(resultado.getString(17));
                    gestionEnSolicitud.setPoliticaAccesoReusoEva(resultado.getString(18));
                    gestionEnSolicitud.setCodigoEticaEva(resultado.getString(19));
                    gestionEnSolicitud.setDeteccionPlagioEva(resultado.getString(20));

                    gestionEnSolicitud.setObservacion15(resultado.getString(21));
                    gestionEnSolicitud.setObservacion16(resultado.getString(22));
                    gestionEnSolicitud.setObservacion17(resultado.getString(23));
                    gestionEnSolicitud.setObservacion18(resultado.getString(24));
                    gestionEnSolicitud.setObservacion19(resultado.getString(25));
                    gestionEnSolicitud.setObservacion20(resultado.getString(26));
                    gestionEnSolicitud.setObservacion21(resultado.getString(27));
                    gestionEnSolicitud.setObservacion22(resultado.getString(28));

                    gestionEnSolicitud.setObservacion15eva(resultado.getString(29));
                    gestionEnSolicitud.setObservacion16eva(resultado.getString(30));
                    gestionEnSolicitud.setObservacion17eva(resultado.getString(31));
                    gestionEnSolicitud.setObservacion18eva(resultado.getString(32));
                    gestionEnSolicitud.setObservacion19eva(resultado.getString(33));
                    gestionEnSolicitud.setObservacion20eva(resultado.getString(34));
                    gestionEnSolicitud.setObservacion21eva(resultado.getString(35));
                    gestionEnSolicitud.setObservacion22eva(resultado.getString(36));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch de solicitaEvaGestion");
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
            revistaConfirmada revistaRecuperada = (revistaConfirmada) misession.getAttribute("revistaRecuperada");
            gestionConfirmados gestionRecuperados = con.solicitaEvaGestion(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("gestionRecuperados", gestionRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="confirmacion" action="confirmaContenido.jsp" method="POST">
            <h3>Criterios de Gestión y Política Editorial</h3>
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
                        <td>15. Definición de la revista</td>
                        <td><textarea name="preCriterio15" rows="3" cols="30"/><%=gestionRecuperados.getDefinicionRevista()%></textarea></td>
                        <td><textarea name="preObCriterio15" rows="3" cols="30"><%=gestionRecuperados.getObservacion15()%></textarea></td>
                        <%if ((gestionRecuperados.getDefinicionRevistaEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio15" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio15" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva15" rows="3" cols="30"><%=gestionRecuperados.getObservacion15eva()%></textarea></td>
                        <td><textarea name="observacionConfirma15" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>16. Autores externos</td>
                        <td><textarea name="preCriterio16" rows="3" cols="30"/>
                            Autores Internos: <%=gestionRecuperados.getAutoresInternos()%>
                            Autores Externos:  <%=gestionRecuperados.getAutoresExternos()%>
                            </textarea>
                        </td>
                        <td><textarea name="preObCriterio16" rows="3" cols="30"><%=gestionRecuperados.getObservacion16()%></textarea></td>
                        <td>
                            <label for="articulosAutoresInternos">Cantidad de documentos con autores internos:</label>
                            <input type="number" id="articulosAutoresInternos" name="articulosAutoresInternos" min="0" max="99" value="<%=gestionRecuperados.getAutoresInternosEva()%>">
                            <br><br>
                            <label for="articulosAutoresExternos">Cantidad de documentos con autores externos:</label>
                            <input type="number" id="articulosAutoresExternos" name="articulosAutoresExternos" min="0" max="99" value="<%=gestionRecuperados.getAutoresExternosEva()%>">
                        </td>
                        <td><textarea name="observacionEva16" rows="3" cols="30"><%=gestionRecuperados.getObservacion16eva()%></textarea></td>
                        <td><textarea name="observacionConfirma16" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>17. Apertura editorial</td>
                        <td><textarea name="preCriterio17" rows="3" cols="30"/>
                            Miembros Internos: <%=gestionRecuperados.getMiembrosInternos()%>
                            Miembros Externos:  <%=gestionRecuperados.getMiembrosExternos()%>
                            </textarea>
                        </td>
                        <td><textarea name="preObCriterio17" rows="3" cols="30"><%=gestionRecuperados.getObservacion17()%></textarea></td>
                        <td>
                            <label for="miembrosInternos">Cantidad de miembros internos:</label>
                            <input type="number" id="miembrosInternos" name="miembrosInternos" min="0" max="99" value="<%=gestionRecuperados.getMiembrosInternosEva()%>">
                            <br><br>
                            <label for="miembrosExternos">Cantidad de miembros externos:</label>
                            <input type="number" id="miembrosExternos" name="miembrosExternos" min="0" max="99" value="<%=gestionRecuperados.getMiembrosExternosEva()%>">
                        </td>
                        <td><textarea name="observacionEva17" rows="3" cols="30"><%=gestionRecuperados.getObservacion17eva()%></textarea></td>
                        <td><textarea name="observacionConfirma17" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>18. Servicios de información</td>
                        <td><textarea name="preCriterio18" rows="3" cols="30"/><%=gestionRecuperados.getServiciosInformacion()%></textarea></td>
                        <td><textarea name="preObCriterio18" rows="3" cols="30"><%=gestionRecuperados.getObservacion18()%></textarea></td>
                        <%if ((gestionRecuperados.getServiciosInformacionEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio18" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio18" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva18" rows="3" cols="30"><%=gestionRecuperados.getObservacion18eva()%></textarea></td>
                        <td><textarea name="observacionConfirma18" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>19. Cumplimiento de periodicidad</td>
                        <td><textarea name="preCriterio19" rows="3" cols="30"/>
                            Fecha de publicación del último número: <%=gestionRecuperados.getCumplimientoPeriodicidad()%></textarea></td>
                        <td><textarea name="preObCriterio19" rows="3" cols="30"><%=gestionRecuperados.getObservacion19()%></textarea></td>
                        <%if ((gestionRecuperados.getCumplimientoPeriodicidadEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" id="checkConfirmaCriterio19" name="checkConfirmaCriterio19" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" id="checkConfirmaCriterio19" name="checkConfirmaCriterio19" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva19" rows="3" cols="30"><%=gestionRecuperados.getObservacion19eva()%></textarea></td>
                        <td><textarea name="observacionConfirma19" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>20. Políticas de acceso y reuso</td>
                        <td><textarea name="preCriterio20" rows="3" cols="30"/><%=gestionRecuperados.getPoliticaAccesoReuso()%></textarea></td>
                        <td><textarea name="preObCriterio20" rows="3" cols="30"><%=gestionRecuperados.getObservacion20()%></textarea></td>
                        <%if ((gestionRecuperados.getPoliticaAccesoReusoEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio20" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio20" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva20" rows="3" cols="30"><%=gestionRecuperados.getObservacion20eva()%></textarea></td>
                        <td><textarea name="observacionConfirma20" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>21. Adopción de códigos de ética</td>
                        <td><textarea name="preCriterio21" rows="3" cols="30"/><%=gestionRecuperados.getCodigoEtica()%></textarea></td>
                        <td><textarea name="preObCriterio21" rows="3" cols="30"><%=gestionRecuperados.getObservacion21()%></textarea></td>
                        <%if ((gestionRecuperados.getCodigoEticaEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio21" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio21" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva21" rows="3" cols="30"><%=gestionRecuperados.getObservacion21eva()%></textarea></td>
                        <td><textarea name="observacionConfirma21" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>22. Detección de plagio</td>
                        <td><textarea name="preCriterio22" rows="3" cols="30"/><%=gestionRecuperados.getDeteccionPlagio()%></textarea></td>
                        <td><textarea name="preObCriterio22" rows="3" cols="30"><%=gestionRecuperados.getObservacion22()%></textarea></td>
                        <%if ((gestionRecuperados.getDeteccionPlagioEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio22" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio22" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva22" rows="3" cols="30"><%=gestionRecuperados.getObservacion22eva()%></textarea></td>
                        <td><textarea name="observacionConfirma22" rows="3" cols="30"></textarea></td>
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

