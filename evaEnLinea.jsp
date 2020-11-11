<%-- 
    Document   : evaEnLinea
    Created on : 29/04/2020, 03:32:26 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.enLineaEvaluados"%>
<%@page import="ucrindex.contenidoEvaluados"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    contenidoEvaluados contenidoRecuperados = (contenidoEvaluados) misession.getAttribute("contenidoRecuperados");
    
    contenidoRecuperados.setDocumentosOriginales(Integer.parseInt(request.getParameter("documentosOriginales")));
    contenidoRecuperados.setOtroTipo(Integer.parseInt(request.getParameter("otrosDocumentos")));
    
    if(request.getParameter("checkCriterio24") != null){
        contenidoRecuperados.setReferenciasBibliograficas("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setReferenciasBibliograficas("No cumple");
    }
    
    if(request.getParameter("checkCriterio25") != null){
        contenidoRecuperados.setExigenciaOriginalidad("Sí cumple");
    }
    else
    {
        contenidoRecuperados.setExigenciaOriginalidad("No cumple");
    }
    
    contenidoRecuperados.setResumen(request.getParameter("checkCriterio26") != null);
    contenidoRecuperados.setResumenDosIdiomas(request.getParameter("checkCriterio27") != null);
    contenidoRecuperados.setPalabras(request.getParameter("checkCriterio28") != null);
    contenidoRecuperados.setPalabrasDosIdiomas(request.getParameter("checkCriterio29")!= null);
    contenidoRecuperados.setCantidadArticulosAnho(Integer.parseInt(request.getParameter("publicadosAnho")));
    
    contenidoRecuperados.setObservacion23(request.getParameter("observacionEva23"));
    contenidoRecuperados.setObservacion24(request.getParameter("observacionEva24"));
    contenidoRecuperados.setObservacion25(request.getParameter("observacionEva25"));
    contenidoRecuperados.setObservacion26(request.getParameter("observacionEva26"));
    contenidoRecuperados.setObservacion27(request.getParameter("observacionEva27"));
    contenidoRecuperados.setObservacion28(request.getParameter("observacionEva28"));
    contenidoRecuperados.setObservacion29(request.getParameter("observacionEva29"));
    contenidoRecuperados.setObservacion30(request.getParameter("observacionEva30"));
    
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

        public enLineaEvaluados solicitaPreEnLinea(String nombreRevista, String organismo) {

            enLineaEvaluados enLineaEnSolicitud = new enLineaEvaluados();

            String consultaSql = "Select criteriosenlinea.interoperabilidad, criteriosenlinea.formatosEdicion, criteriosenlinea.valorAgregado,"
                    + " criteriosenlinea.interactividad, criteriosenlinea.buscadores, criteriosenlinea.identificadoresDeRecurso, criteriosenlinea.estadisticas,"
                    + " criteriosenlinea.politicaPreservacion, "
                    + " observacionessolicitudlatindex.observacion31, observacionessolicitudlatindex.observacion32, observacionessolicitudlatindex.observacion33, observacionessolicitudlatindex.observacion34,"
                    + " observacionessolicitudlatindex.observacion35, observacionessolicitudlatindex.observacion36, observacionessolicitudlatindex.observacion37, observacionessolicitudlatindex.observacion38"
                    + " FROM datosrevista, criteriosenlinea, observacionessolicitudlatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriosenlinea.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            //System.out.println(consultaSql);
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
                       
            revistaEvaluada revistaRecuperada = (revistaEvaluada) misession.getAttribute("revistaRecuperada");
            enLineaEvaluados enLineaRecuperados = con.solicitaPreEnLinea(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("enLineaRecuperados", enLineaRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="evaluacion" action="calculoNotaLatindex.jsp" method="POST">
            <h3>Criterios de Revistas En Línea</h3>
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
                        <td>31. Uso de protocolos de interoperabilidad</td>
                        <td><textarea name="preCriterio31" rows="3" cols="30"/><%=enLineaRecuperados.getInteroperabilidad()%></textarea></td>
                        <td><textarea name="preObCriterio31" rows="3" cols="30"><%=enLineaRecuperados.getObservacion31()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio31" value="ON" /></td>
                        <td><textarea name="observacionEva31" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>32. Uso de diferentes formatos de edición </td>
                        <%if(enLineaRecuperados.getFormatosEdicion()){%>
                        <td><textarea name="preCriterio32" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio32" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio32" rows="3" cols="30"><%=enLineaRecuperados.getObservacion32()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio32" value="ON" /></td>
                        <td><textarea name="observacionEva32" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>33. Servicios de valor agregado </td>
                        <td><textarea name="preCriterio33" rows="3" cols="30"/><%=enLineaRecuperados.getValorAgregado()%></textarea></td>
                        <td><textarea name="preObCriterio33" rows="3" cols="30"><%=enLineaRecuperados.getObservacion33()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio33" value="ON" /></td>
                        <td><textarea name="observacionEva33" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>34. Servicios de interactividad con el lector</td>
                        <td><textarea name="preCriterio34" rows="3" cols="30"/><%=enLineaRecuperados.getInteractividad()%></textarea></td>
                        <td><textarea name="preObCriterio34" rows="3" cols="30"><%=enLineaRecuperados.getObservacion34()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio34" value="ON" /></td>
                        <td><textarea name="observacionEva34" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>35. Buscadores</td>
                        <td><textarea name="preCriterio35" rows="3" cols="30"/><%=enLineaRecuperados.getBuscadores()%></textarea></td>
                        <td><textarea name="preObCriterio35" rows="3" cols="30"><%=enLineaRecuperados.getObservacion35()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio35" value="ON" /></td>
                        <td><textarea name="observacionEva35" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>36. Uso de identificadores de recursos uniforme</td>
                        <%if(enLineaRecuperados.getIdentificadoresDeRecurso()){%>
                        <td><textarea name="preCriterio36" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio36" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio36" rows="3" cols="30"><%=enLineaRecuperados.getObservacion36()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio36" value="ON" /></td>
                        <td><textarea name="observacionEva36" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>37. Uso de estadísticas</td>
                        <td><textarea name="preCriterio37" rows="3" cols="30"/><%=enLineaRecuperados.getEstadisticas()%></textarea></td>
                        <td><textarea name="preObCriterio37" rows="3" cols="30"><%=enLineaRecuperados.getObservacion37()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio37" value="ON" /></td>
                        <td><textarea name="observacionEva37" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>38. Políticas de preservación digital</td>
                        <td><textarea name="preCriterio38" rows="3" cols="30"/><%=enLineaRecuperados.getPoliticaPreservacion()%></textarea></td>
                        <td><textarea name="preObCriterio38" rows="3" cols="30"><%=enLineaRecuperados.getObservacion38()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio38" value="ON" /></td>
                        <td><textarea name="observacionEva38" rows="3" cols="30"></textarea></td>
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
