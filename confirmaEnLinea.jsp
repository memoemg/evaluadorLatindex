<%-- 
    Document   : confirmaEnLinea
    Created on : 09/08/2020, 12:30:12 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.enLineaConfirmados"%>
<%@page import="ucrindex.contenidoConfirmados"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    contenidoConfirmados contenidoRecuperados = (contenidoConfirmados) misession.getAttribute("contenidoRecuperados");
    
    contenidoRecuperados.setDocumentosOriginalesEva(request.getParameter("documentosOriginales"));
    contenidoRecuperados.setOtroTipoEva(request.getParameter("otrosDocumentos"));
    
    if(request.getParameter("checkConfirmaCriterio24") != null){
        contenidoRecuperados.setReferenciasBibliograficasEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setReferenciasBibliograficasEva("No cumple");
    }
    
    if(request.getParameter("checkConfirmaCriterio25") != null){
        contenidoRecuperados.setExigenciaOriginalidadEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setExigenciaOriginalidadEva("No cumple");
    }
    
    if(request.getParameter("checkConfirmaCriterio26") != null){
        contenidoRecuperados.setResumenEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setResumenEva("No cumple");
    }
        
    
    if(request.getParameter("checkConfirmaCriterio27") != null){
        contenidoRecuperados.setResumenDosIdiomasEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setResumenDosIdiomasEva("No cumple");
    }
        
    if(request.getParameter("checkConfirmaCriterio28") != null){
        contenidoRecuperados.setPalabrasEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setPalabrasEva("No cumple");
    }
        
    
    if(request.getParameter("checkConfirmaCriterio29") != null){
        contenidoRecuperados.setPalabrasDosIdiomasEva("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setPalabrasDosIdiomasEva("No cumple");
    }
        
    contenidoRecuperados.setCantidadArticulosAnhoEva(request.getParameter("publicadosAnho"));
    
    contenidoRecuperados.setObservacion23eva(request.getParameter("observacionEva23"));
    contenidoRecuperados.setObservacion24eva(request.getParameter("observacionEva24"));
    contenidoRecuperados.setObservacion25eva(request.getParameter("observacionEva25"));
    contenidoRecuperados.setObservacion26eva(request.getParameter("observacionEva26"));
    contenidoRecuperados.setObservacion27eva(request.getParameter("observacionEva27"));
    contenidoRecuperados.setObservacion28eva(request.getParameter("observacionEva28"));
    contenidoRecuperados.setObservacion29eva(request.getParameter("observacionEva29"));
    contenidoRecuperados.setObservacion30eva(request.getParameter("observacionEva30"));
    
    contenidoRecuperados.setObservacion23confirma(request.getParameter("observacionConfirma23"));
    contenidoRecuperados.setObservacion24confirma(request.getParameter("observacionConfirma24"));
    contenidoRecuperados.setObservacion25confirma(request.getParameter("observacionConfirma25"));
    contenidoRecuperados.setObservacion26confirma(request.getParameter("observacionConfirma26"));
    contenidoRecuperados.setObservacion27confirma(request.getParameter("observacionConfirma27"));
    contenidoRecuperados.setObservacion28confirma(request.getParameter("observacionConfirma28"));
    contenidoRecuperados.setObservacion29confirma(request.getParameter("observacionConfirma29"));
    contenidoRecuperados.setObservacion30confirma(request.getParameter("observacionConfirma30"));
    
    misession.setAttribute("contenidoRecuperados", contenidoRecuperados);
    
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

        public enLineaConfirmados solicitaEvaEnLinea(String nombreRevista, String organismo) {

            enLineaConfirmados enLineaEnSolicitud = new enLineaConfirmados();

            String consultaSql = "Select criteriosenlinea.interoperabilidad, criteriosenlinea.formatosEdicion, criteriosenlinea.valorAgregado,"
                    + " criteriosenlinea.interactividad, criteriosenlinea.buscadores, criteriosenlinea.identificadoresDeRecurso, criteriosenlinea.estadisticas,"
                    + " criteriosenlinea.politicaPreservacion, "
                    + " observacionessolicitudlatindex.observacion31, observacionessolicitudlatindex.observacion32, observacionessolicitudlatindex.observacion33, observacionessolicitudlatindex.observacion34,"
                    + " observacionessolicitudlatindex.observacion35, observacionessolicitudlatindex.observacion36, observacionessolicitudlatindex.observacion37, observacionessolicitudlatindex.observacion38,"
                    + " evaenlinea.interoperabilidad, evaenlinea.formatosEdicion, evaenlinea.valorAgregado,"
                    + " evaenlinea.interactividad, evaenlinea.buscadores, evaenlinea.identificadoresDeRecurso, evaenlinea.estadisticas,"
                    + " evaenlinea.politicaPreservacion, "
                    + " observacionesevalatindex.observacionEva31, observacionesevalatindex.observacionEva32, observacionesevalatindex.observacionEva33, observacionesevalatindex.observacionEva34,"
                    + " observacionesevalatindex.observacionEva35, observacionesevalatindex.observacionEva36, observacionesevalatindex.observacionEva37, observacionesevalatindex.observacionEva38"
                    + " FROM datosrevista, criteriosenlinea, observacionessolicitudlatindex, evaenlinea, observacionesevalatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = evaenlinea.issnRevista AND datosrevista.issn = observacionesevalatindex.issnRevista AND datosrevista.issn = criteriosenlinea.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    enLineaEnSolicitud.setInteroperabilidad(resultado.getString(1));
                    enLineaEnSolicitud.setFormatosEdicion(resultado.getBoolean(2));
                    enLineaEnSolicitud.setValorAgregado(resultado.getString(3));
                    enLineaEnSolicitud.setInteractividad(resultado.getString(4));
                    enLineaEnSolicitud.setBuscadores(resultado.getString(5));
                    enLineaEnSolicitud.setIdentificadoresDeRecurso(resultado.getBoolean(6));
                    enLineaEnSolicitud.setEstadisticas(resultado.getString(7));
                    enLineaEnSolicitud.setPoliticaPreservacion(resultado.getString(8));

                    enLineaEnSolicitud.setObservacion31(resultado.getString(9));
                    enLineaEnSolicitud.setObservacion32(resultado.getString(10));
                    enLineaEnSolicitud.setObservacion33(resultado.getString(11));
                    enLineaEnSolicitud.setObservacion34(resultado.getString(12));
                    enLineaEnSolicitud.setObservacion35(resultado.getString(13));
                    enLineaEnSolicitud.setObservacion36(resultado.getString(14));
                    enLineaEnSolicitud.setObservacion37(resultado.getString(15));
                    enLineaEnSolicitud.setObservacion38(resultado.getString(16));

                    enLineaEnSolicitud.setInteroperabilidadEva(resultado.getString(17));
                    enLineaEnSolicitud.setFormatosEdicionEva(resultado.getString(18));
                    enLineaEnSolicitud.setValorAgregadoEva(resultado.getString(19));
                    enLineaEnSolicitud.setInteractividadEva(resultado.getString(20));
                    enLineaEnSolicitud.setBuscadoresEva(resultado.getString(21));
                    enLineaEnSolicitud.setIdentificadoresDeRecursoEva(resultado.getString(22));
                    enLineaEnSolicitud.setEstadisticasEva(resultado.getString(23));
                    enLineaEnSolicitud.setPoliticaPreservacionEva(resultado.getString(24));

                    enLineaEnSolicitud.setObservacion31eva(resultado.getString(25));
                    enLineaEnSolicitud.setObservacion32eva(resultado.getString(26));
                    enLineaEnSolicitud.setObservacion33eva(resultado.getString(27));
                    enLineaEnSolicitud.setObservacion34eva(resultado.getString(28));
                    enLineaEnSolicitud.setObservacion35eva(resultado.getString(29));
                    enLineaEnSolicitud.setObservacion36eva(resultado.getString(30));
                    enLineaEnSolicitud.setObservacion37eva(resultado.getString(31));
                    enLineaEnSolicitud.setObservacion38eva(resultado.getString(32));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return enLineaEnSolicitud;
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
            enLineaConfirmados enLineaRecuperados = con.solicitaEvaEnLinea(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("enLineaRecuperados", enLineaRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="confirmacion" action="calculoNotaLatindexConfirmada.jsp" method="POST">
            <h3>Criterios de Revistas En Línea</h3>
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
                        <td>31. Uso de protocolos de interoperabilidad</td>
                        <td><textarea name="preCriterio31" rows="3" cols="30"/><%=enLineaRecuperados.getInteroperabilidad()%></textarea></td>
                        <td><textarea name="preObCriterio31" rows="3" cols="30"><%=enLineaRecuperados.getObservacion31()%></textarea></td>
                        <%if ((enLineaRecuperados.getInteroperabilidadEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio31" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio31" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva31" rows="3" cols="30"><%=enLineaRecuperados.getObservacion31eva()%></textarea></td>
                        <td><textarea name="observacionConfirma31" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>32. Uso de diferentes formatos de edición </td>
                        <%if(enLineaRecuperados.getFormatosEdicion()){%>
                        <td><textarea name="preCriterio32" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio32" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio32" rows="3" cols="30"><%=enLineaRecuperados.getObservacion32()%></textarea></td>
                        <%if ((enLineaRecuperados.getFormatosEdicionEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio32" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio32" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva32" rows="3" cols="30"><%=enLineaRecuperados.getObservacion32eva()%></textarea></td>
                        <td><textarea name="observacionConfirma32" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>33. Servicios de valor agregado </td>
                        <td><textarea name="preCriterio33" rows="3" cols="30"/><%=enLineaRecuperados.getValorAgregado()%></textarea></td>
                        <td><textarea name="preObCriterio33" rows="3" cols="30"><%=enLineaRecuperados.getObservacion33()%></textarea></td>
                        <%if ((enLineaRecuperados.getValorAgregadoEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio33" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio33" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva33" rows="3" cols="30"><%=enLineaRecuperados.getObservacion33eva()%></textarea></td>
                        <td><textarea name="observacionConfirma33" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>34. Servicios de interactividad con el lector</td>
                        <td><textarea name="preCriterio34" rows="3" cols="30"/><%=enLineaRecuperados.getInteractividad()%></textarea></td>
                        <td><textarea name="preObCriterio34" rows="3" cols="30"><%=enLineaRecuperados.getObservacion34()%></textarea></td>
                        <%if ((enLineaRecuperados.getInteractividadEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio34" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio34" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva34" rows="3" cols="30"><%=enLineaRecuperados.getObservacion34eva()%></textarea></td>
                        <td><textarea name="observacionConfirma34" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>35. Buscadores</td>
                        <td><textarea name="preCriterio35" rows="3" cols="30"/><%=enLineaRecuperados.getBuscadores()%></textarea></td>
                        <td><textarea name="preObCriterio35" rows="3" cols="30"><%=enLineaRecuperados.getObservacion35()%></textarea></td>
                        <%if ((enLineaRecuperados.getBuscadoresEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio35" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio35" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva35" rows="3" cols="30"><%=enLineaRecuperados.getObservacion35eva()%></textarea></td>
                        <td><textarea name="observacionConfirma35" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>36. Uso de identificadores de recursos uniforme</td>
                        <%if(enLineaRecuperados.getIdentificadoresDeRecurso()){%>
                        <td><textarea name="preCriterio36" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio36" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio36" rows="3" cols="30"><%=enLineaRecuperados.getObservacion36()%></textarea></td>
                        <%if ((enLineaRecuperados.getIdentificadoresDeRecursoEva().equals("1"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio36" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio36" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva36" rows="3" cols="30"><%=enLineaRecuperados.getObservacion36eva()%></textarea></td>
                        <td><textarea name="observacionConfirma36" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>37. Uso de estadísticas</td>
                        <td><textarea name="preCriterio37" rows="3" cols="30"/><%=enLineaRecuperados.getEstadisticas()%></textarea></td>
                        <td><textarea name="preObCriterio37" rows="3" cols="30"><%=enLineaRecuperados.getObservacion37()%></textarea></td>
                        <%if ((enLineaRecuperados.getEstadisticasEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio37" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio37" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva37" rows="3" cols="30"><%=enLineaRecuperados.getObservacion37eva()%></textarea></td>
                        <td><textarea name="observacionConfirma37" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>38. Políticas de preservación digital</td>
                        <td><textarea name="preCriterio38" rows="3" cols="30"/><%=enLineaRecuperados.getPoliticaPreservacion()%></textarea></td>
                        <td><textarea name="preObCriterio38" rows="3" cols="30"><%=enLineaRecuperados.getObservacion38()%></textarea></td>
                        <%if ((enLineaRecuperados.getPoliticaPreservacionEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio38" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio38" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva38" rows="3" cols="30"><%=enLineaRecuperados.getObservacion38eva()%></textarea></td>
                        <td><textarea name="observacionConfirma38" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>

            <br>
            <div id="botonSiguiente">
                <button type="button" name="back" onclick="history.back()">ATRÁS</button>
                <input type="submit" value="Calcular Nota" name="enviarEnLinea"/>
            </div>      
        </form>
    </body>
</html>

