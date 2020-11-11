<%-- 
    Document   : evaContenido
    Created on : 29/04/2020, 02:45:18 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.contenidoEvaluados"%>
<%@page import="ucrindex.gestionEvaluados"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    gestionEvaluados gestionRecuperados = (gestionEvaluados) misession.getAttribute("gestionRecuperados");
    
    if(request.getParameter("checkCriterio15") != null){
        gestionRecuperados.setDefinicionRevista("Sí cumple");
    }
    else
    {
        gestionRecuperados.setDefinicionRevista("No cumple");
    }
    
    gestionRecuperados.setAutoresExternos(Integer.parseInt(request.getParameter("articulosAutoresExternos")));
    gestionRecuperados.setAutoresInternos(Integer.parseInt(request.getParameter("articulosAutoresInternos")));
    gestionRecuperados.setMiembrosExternos(Integer.parseInt(request.getParameter("miembrosExternos")));
    gestionRecuperados.setMiembrosInternos(Integer.parseInt(request.getParameter("miembrosInternos")));
    
    if(request.getParameter("checkCriterio18") != null){
        gestionRecuperados.setServiciosInformacion("Sí cumple");
    }
    else
    {
        gestionRecuperados.setServiciosInformacion("No cumple");
    }
    
    if(request.getParameter("checkCriterio19") != null){
        gestionRecuperados.setCumplimientoPeriodicidad("Sí cumple");
    }
    else
    {
        gestionRecuperados.setCumplimientoPeriodicidad("No cumple");
    }
    
    if(request.getParameter("checkCriterio20") != null){
        gestionRecuperados.setPoliticaAccesoReuso("Sí cumple");
    }
    else
    {
        gestionRecuperados.setPoliticaAccesoReuso("No cumple");
    }
    
    if(request.getParameter("checkCriterio21") != null){
        gestionRecuperados.setCodigoEtica("Sí cumple");
    }
    else
    {
        gestionRecuperados.setCodigoEtica("No cumple");
    }
    
    if(request.getParameter("checkCriterio22") != null){
        gestionRecuperados.setDeteccionPlagio("Sí cumple");
    }
    else
    {
        gestionRecuperados.setDeteccionPlagio("No cumple");
    }
    
    gestionRecuperados.setObservacion15(request.getParameter("observacionEva15"));
    gestionRecuperados.setObservacion16(request.getParameter("observacionEva16"));
    gestionRecuperados.setObservacion17(request.getParameter("observacionEva17"));
    gestionRecuperados.setObservacion18(request.getParameter("observacionEva18"));
    gestionRecuperados.setObservacion19(request.getParameter("observacionEva19"));
    gestionRecuperados.setObservacion20(request.getParameter("observacionEva20"));
    gestionRecuperados.setObservacion21(request.getParameter("observacionEva21"));
    gestionRecuperados.setObservacion22(request.getParameter("observacionEva22"));
    
    misession.setAttribute("gestionRecuperados", gestionRecuperados);
    
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

        public contenidoEvaluados solicitaPreContenido(String nombreRevista, String organismo) {

            contenidoEvaluados contenidoEnSolicitud = new contenidoEvaluados();

            String consultaSql = "Select criterioscontenido.documentosOriginales, criterioscontenido.otrosTipos, criterioscontenido.referenciasBibliograficas,"
                    + " criterioscontenido.exigenciaOriginalidad, criterioscontenido.resumen, criterioscontenido.resumenDosIdiomas, criterioscontenido.palabras,"
                    + " criterioscontenido.palabrasDosIdiomas, criterioscontenido.cantidadArticulosAnho,"
                    + " observacionessolicitudlatindex.observacion23, observacionessolicitudlatindex.observacion24, observacionessolicitudlatindex.observacion25, observacionessolicitudlatindex.observacion26,"
                    + " observacionessolicitudlatindex.observacion27, observacionessolicitudlatindex.observacion28, observacionessolicitudlatindex.observacion29, observacionessolicitudlatindex.observacion30"
                    + " FROM datosrevista, criterioscontenido, observacionessolicitudlatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criterioscontenido.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    contenidoEnSolicitud.setDocumentosOriginales(resultado.getInt(1));
                    contenidoEnSolicitud.setOtroTipo(resultado.getInt(2));
                    contenidoEnSolicitud.setReferenciasBibliograficas(resultado.getString(3));
                    contenidoEnSolicitud.setExigenciaOriginalidad(resultado.getString(4));
                    contenidoEnSolicitud.setResumen(resultado.getBoolean(5));
                    contenidoEnSolicitud.setResumenDosIdiomas(resultado.getBoolean(6));
                    contenidoEnSolicitud.setPalabras(resultado.getBoolean(7));
                    contenidoEnSolicitud.setPalabrasDosIdiomas(resultado.getBoolean(8));
                    contenidoEnSolicitud.setCantidadArticulosAnho(resultado.getInt(9));

                    contenidoEnSolicitud.setObservacion23(resultado.getString(10));
                    contenidoEnSolicitud.setObservacion24(resultado.getString(11));
                    contenidoEnSolicitud.setObservacion25(resultado.getString(12));
                    contenidoEnSolicitud.setObservacion26(resultado.getString(13));
                    contenidoEnSolicitud.setObservacion27(resultado.getString(14));
                    contenidoEnSolicitud.setObservacion28(resultado.getString(15));
                    contenidoEnSolicitud.setObservacion29(resultado.getString(16));
                    contenidoEnSolicitud.setObservacion30(resultado.getString(17));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return contenidoEnSolicitud;
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
            contenidoEvaluados contenidoRecuperados = con.solicitaPreContenido(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("contenidoRecuperados", contenidoRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="evaluacion" action="evaEnLinea.jsp" method="POST">
            <h3>Criterios de Contenido</h3>
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
                        <td>23. Contenido original</td>
                        <td><textarea name="preCriterio23" rows="3" cols="30"/>
                            Documentos originales: <%=contenidoRecuperados.getDocumentosOriginales()%>
                            Otro tipo:  <%=contenidoRecuperados.getOtroTipo()%>
                            </textarea></td>
                        <td><textarea name="preObCriterio23" rows="3" cols="30"><%=contenidoRecuperados.getObservacion23()%></textarea></td>
                        <td>
                            <label for="documentosOriginales">Cantidad de documentos originales:</label>
                            <input type="number" id="documentosOriginales" name="documentosOriginales" min="0" max="99" value="0">
                            <br><br>
                            <label for="otrosDocumentos">Cantidad de otros tipos de documento:</label>
                            <input type="number" id="otrosDocumentos" name="otrosDocumentos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEva23" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>24. Elaboración de las referencias bibliográficas</td>
                        <td><textarea name="preCriterio24" rows="3" cols="30"/><%=contenidoRecuperados.getReferenciasBibliograficas()%></textarea></td>
                        <td><textarea name="preObCriterio24" rows="3" cols="30"><%=contenidoRecuperados.getObservacion24()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio24" value="ON" /></td>
                        <td><textarea name="observacionEva24" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>25. Exigencia de originalidad </td>
                        <td><textarea name="preCriterio25" rows="3" cols="30"/><%=contenidoRecuperados.getExigenciaOriginalidad()%></textarea></td>
                        <td><textarea name="preObCriterio25" rows="3" cols="30"><%=contenidoRecuperados.getObservacion25()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio25" value="ON" /></td>
                        <td><textarea name="observacionEva25" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>26. Resumen</td>
                        <%if(contenidoRecuperados.getResumen()){%>
                        <td><textarea name="preCriterio26" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio26" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio26" rows="3" cols="30"><%=contenidoRecuperados.getObservacion26()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio26" value="ON" /></td>
                        <td><textarea name="observacionEva26" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>27. Resumen en dos idiomas</td>
                        <%if(contenidoRecuperados.getResumenDosIdiomas()){%>
                        <td><textarea name="preCriterio27" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio27" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio27" rows="3" cols="30"><%=contenidoRecuperados.getObservacion27()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio27" value="ON" /></td>
                        <td><textarea name="observacionEva27" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>28. Palabras clave</td>
                        <%if(contenidoRecuperados.getPalabras()){%>
                        <td><textarea name="preCriterio28" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio28" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio28" rows="3" cols="30"><%=contenidoRecuperados.getObservacion28()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio28" value="ON" /></td>
                        <td><textarea name="observacionEva28" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>29. Palabras clave en dos idiomas</td>
                        <%if(contenidoRecuperados.getPalabrasDosIdiomas()){%>
                        <td><textarea name="preCriterio29" rows="3" cols="30"/>Sí cumple</textarea></td>
                         <%}else{%>
                        <td><textarea name="preCriterio29" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio29" rows="3" cols="30"><%=contenidoRecuperados.getObservacion29()%></textarea></td>
                        <td><input type="checkbox" name="checkCriterio29" value="ON" /></td>
                        <td><textarea name="observacionEva29" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>30. Cantidad de artículos publicados por año</td>
                        <td><textarea name="preCriterio30" rows="3" cols="30"/><%=contenidoRecuperados.getCantidadArticulosAnho()%></textarea></td>
                        <td><textarea name="preObCriterio30" rows="3" cols="30"><%=contenidoRecuperados.getObservacion30()%></textarea></td>
                        <td>
                            <label for="publicadosAnho">Cantidad de artículos:</label>
                            <input type="number" id="publicadosAnho" name="publicadosAnho" min="0" max="199" value="0">
                        </td>
                        <td><textarea name="observacionEva30" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>

            <br>
            <div id="botonSiguiente">
                <button type="button" name="back" onclick="history.back()">ATRÁS</button>
                <input type="submit" value="SIGUIENTE" name="enviarContenido"/>
            </div>      
        </form>
    </body>
</html>
