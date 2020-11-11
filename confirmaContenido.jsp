<%-- 
    Document   : confirmaContenido
    Created on : 08/08/2020, 05:15:41 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.contenidoConfirmados"%>
<%@page import="ucrindex.gestionConfirmados"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    gestionConfirmados gestionRecuperados = (gestionConfirmados) misession.getAttribute("gestionRecuperados");

    if (request.getParameter("checkConfirmaCriterio15") != null) {
        gestionRecuperados.setDefinicionRevistaEva("Sí cumple");
    } else {
        gestionRecuperados.setDefinicionRevistaEva("No cumple");
    }

    gestionRecuperados.setAutoresExternosEva(request.getParameter("articulosAutoresExternos"));
    gestionRecuperados.setAutoresInternosEva(request.getParameter("articulosAutoresInternos"));
    gestionRecuperados.setMiembrosExternosEva(request.getParameter("miembrosExternos"));
    gestionRecuperados.setMiembrosInternosEva(request.getParameter("miembrosInternos"));

    if (request.getParameter("checkConfirmaCriterio18") != null) {
        gestionRecuperados.setServiciosInformacionEva("Sí cumple");
    } else {
        gestionRecuperados.setServiciosInformacionEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio19") != null) {
        gestionRecuperados.setCumplimientoPeriodicidadEva("Sí cumple");
    } else {
        gestionRecuperados.setCumplimientoPeriodicidadEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio20") != null) {
        gestionRecuperados.setPoliticaAccesoReusoEva("Sí cumple");
    } else {
        gestionRecuperados.setPoliticaAccesoReusoEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio21") != null) {
        gestionRecuperados.setCodigoEticaEva("Sí cumple");
    } else {
        gestionRecuperados.setCodigoEticaEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio22") != null) {
        gestionRecuperados.setDeteccionPlagioEva("Sí cumple");
    } else {
        gestionRecuperados.setDeteccionPlagioEva("No cumple");
    }

    gestionRecuperados.setObservacion15eva(request.getParameter("observacionEva15"));
    gestionRecuperados.setObservacion16eva(request.getParameter("observacionEva16"));
    gestionRecuperados.setObservacion17eva(request.getParameter("observacionEva17"));
    gestionRecuperados.setObservacion18eva(request.getParameter("observacionEva18"));
    gestionRecuperados.setObservacion19eva(request.getParameter("observacionEva19"));
    gestionRecuperados.setObservacion20eva(request.getParameter("observacionEva20"));
    gestionRecuperados.setObservacion21eva(request.getParameter("observacionEva21"));
    gestionRecuperados.setObservacion22eva(request.getParameter("observacionEva22"));
    
    gestionRecuperados.setObservacion15confirma(request.getParameter("observacionConfirma15"));
    gestionRecuperados.setObservacion16confirma(request.getParameter("observacionConfirma16"));
    gestionRecuperados.setObservacion17confirma(request.getParameter("observacionConfirma17"));
    gestionRecuperados.setObservacion18confirma(request.getParameter("observacionConfirma18"));
    gestionRecuperados.setObservacion19confirma(request.getParameter("observacionConfirma19"));
    gestionRecuperados.setObservacion20confirma(request.getParameter("observacionConfirma20"));
    gestionRecuperados.setObservacion21confirma(request.getParameter("observacionConfirma21"));
    gestionRecuperados.setObservacion22confirma(request.getParameter("observacionConfirma22"));

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

        public contenidoConfirmados solicitaEvaContenido(String nombreRevista, String organismo) {

            contenidoConfirmados contenidoEnSolicitud = new contenidoConfirmados();

            String consultaSql = "Select criterioscontenido.documentosOriginales, criterioscontenido.otrosTipos, criterioscontenido.referenciasBibliograficas,"
                    + " criterioscontenido.exigenciaOriginalidad, criterioscontenido.resumen, criterioscontenido.resumenDosIdiomas, criterioscontenido.palabras,"
                    + " criterioscontenido.palabrasDosIdiomas, criterioscontenido.cantidadArticulosAnho,"
                    + " evacontenido.documentosOriginales, evacontenido.otrosTipos, evacontenido.referenciasBibliograficas,"
                    + " evacontenido.exigenciaOriginalidad, evacontenido.resumen, evacontenido.resumenDosIdiomas, evacontenido.palabras,"
                    + " evacontenido.palabrasDosIdiomas, evacontenido.cantidadArticulosAnho,"
                    + " observacionessolicitudlatindex.observacion23, observacionessolicitudlatindex.observacion24, observacionessolicitudlatindex.observacion25, observacionessolicitudlatindex.observacion26,"
                    + " observacionessolicitudlatindex.observacion27, observacionessolicitudlatindex.observacion28, observacionessolicitudlatindex.observacion29, observacionessolicitudlatindex.observacion30,"
                    + " observacionesevalatindex.observacionEva23, observacionesevalatindex.observacionEva24, observacionesevalatindex.observacionEva25, observacionesevalatindex.observacionEva26,"
                    + " observacionesevalatindex.observacionEva27, observacionesevalatindex.observacionEva28, observacionesevalatindex.observacionEva29, observacionesevalatindex.observacionEva30"
                    + " FROM datosrevista, criterioscontenido, evacontenido, observacionesevalatindex, observacionessolicitudlatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = evacontenido.issnRevista AND datosrevista.issn = observacionesevalatindex.issnRevista AND datosrevista.issn = criterioscontenido.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista;";
            System.out.println(consultaSql);
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

                    contenidoEnSolicitud.setDocumentosOriginalesEva(resultado.getString(10));
                    contenidoEnSolicitud.setOtroTipoEva(resultado.getString(11));
                    contenidoEnSolicitud.setReferenciasBibliograficasEva(resultado.getString(12));
                    contenidoEnSolicitud.setExigenciaOriginalidadEva(resultado.getString(13));
                    contenidoEnSolicitud.setResumenEva(resultado.getString(14));
                    contenidoEnSolicitud.setResumenDosIdiomasEva(resultado.getString(15));
                    contenidoEnSolicitud.setPalabrasEva(resultado.getString(16));
                    contenidoEnSolicitud.setPalabrasDosIdiomasEva(resultado.getString(17));
                    contenidoEnSolicitud.setCantidadArticulosAnhoEva(resultado.getString(18));

                    contenidoEnSolicitud.setObservacion23(resultado.getString(19));
                    contenidoEnSolicitud.setObservacion24(resultado.getString(20));
                    contenidoEnSolicitud.setObservacion25(resultado.getString(21));
                    contenidoEnSolicitud.setObservacion26(resultado.getString(22));
                    contenidoEnSolicitud.setObservacion27(resultado.getString(23));
                    contenidoEnSolicitud.setObservacion28(resultado.getString(24));
                    contenidoEnSolicitud.setObservacion29(resultado.getString(25));
                    contenidoEnSolicitud.setObservacion30(resultado.getString(26));

                    contenidoEnSolicitud.setObservacion23eva(resultado.getString(27));
                    contenidoEnSolicitud.setObservacion24eva(resultado.getString(28));
                    contenidoEnSolicitud.setObservacion25eva(resultado.getString(29));
                    contenidoEnSolicitud.setObservacion26eva(resultado.getString(30));
                    contenidoEnSolicitud.setObservacion27eva(resultado.getString(31));
                    contenidoEnSolicitud.setObservacion28eva(resultado.getString(32));
                    contenidoEnSolicitud.setObservacion29eva(resultado.getString(33));
                    contenidoEnSolicitud.setObservacion30eva(resultado.getString(34));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch de solicitaEvaContenido");
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
            revistaConfirmada revistaRecuperada = (revistaConfirmada) misession.getAttribute("revistaRecuperada");
            contenidoConfirmados contenidoRecuperados = con.solicitaEvaContenido(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("contenidoRecuperados", contenidoRecuperados);
        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="confirmacion" action="confirmaEnLinea.jsp" method="POST">
            <h3>Criterios de Contenido</h3>
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
                        <td>23. Contenido original</td>
                        <td><textarea name="preCriterio23" rows="3" cols="30"/>
                            Documentos originales: <%=contenidoRecuperados.getDocumentosOriginales()%>
                            Otro tipo:  <%=contenidoRecuperados.getOtroTipo()%>
                            </textarea>
                        </td>
                        <td><textarea name="preObCriterio23" rows="3" cols="30"><%=contenidoRecuperados.getObservacion23()%></textarea></td>
                        <td>
                            <label for="documentosOriginales">Cantidad de documentos originales:</label>
                            <input type="number" id="documentosOriginales" name="documentosOriginales" min="0" max="99" value="<%=contenidoRecuperados.getDocumentosOriginalesEva()%>">
                            <br><br>
                            <label for="otrosDocumentos">Cantidad de otros tipos de documento:</label>
                            <input type="number" id="otrosDocumentos" name="otrosDocumentos" min="0" max="99" value="<%=contenidoRecuperados.getOtroTipoEva()%>">
                        </td>
                        <td><textarea name="observacionEva23" rows="3" cols="30"><%=contenidoRecuperados.getObservacion23eva()%></textarea></td>
                        <td><textarea name="observacionConfirma23" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>24. Elaboración de las referencias bibliográficas</td>
                        <td><textarea name="preCriterio24" rows="3" cols="30"/><%=contenidoRecuperados.getReferenciasBibliograficas()%></textarea></td>
                        <td><textarea name="preObCriterio24" rows="3" cols="30"><%=contenidoRecuperados.getObservacion24()%></textarea></td>
                            <%if ((contenidoRecuperados.getReferenciasBibliograficasEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio24" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio24" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva24" rows="3" cols="30"><%=contenidoRecuperados.getObservacion24eva()%></textarea></td>
                        <td><textarea name="observacionConfirma24" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>25. Exigencia de originalidad </td>
                        <td><textarea name="preCriterio25" rows="3" cols="30"/><%=contenidoRecuperados.getExigenciaOriginalidad()%></textarea></td>
                        <td><textarea name="preObCriterio25" rows="3" cols="30"><%=contenidoRecuperados.getObservacion25()%></textarea></td>
                            <%if ((contenidoRecuperados.getExigenciaOriginalidadEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio25" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio25" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva25" rows="3" cols="30"><%=contenidoRecuperados.getObservacion25eva()%></textarea></td>
                        <td><textarea name="observacionConfirma25" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>26. Resumen</td>
                        <%if (contenidoRecuperados.getResumen()) {%>
                        <td><textarea name="preCriterio26" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio26" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio26" rows="3" cols="30"><%=contenidoRecuperados.getObservacion26()%></textarea></td>
                            <%if (contenidoRecuperados.getResumenEva().equals("1")) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio26" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio26" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva26" rows="3" cols="30"><%=contenidoRecuperados.getObservacion26eva()%></textarea></td>
                        <td><textarea name="observacionConfirma26" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>27. Resumen en dos idiomas</td>
                        <%if (contenidoRecuperados.getResumenDosIdiomas()) {%>
                        <td><textarea name="preCriterio27" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio27" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio27" rows="3" cols="30"><%=contenidoRecuperados.getObservacion27()%></textarea></td>
                            <%if (contenidoRecuperados.getResumenDosIdiomasEva().equals("1")) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio27" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio27" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva27" rows="3" cols="30"><%=contenidoRecuperados.getObservacion27eva()%></textarea></td>
                        <td><textarea name="observacionConfirma27" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>28. Palabras clave</td>
                        <%if (contenidoRecuperados.getPalabras()) {%>
                        <td><textarea name="preCriterio28" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio28" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio28" rows="3" cols="30"><%=contenidoRecuperados.getObservacion28()%></textarea></td>
                            <%if (contenidoRecuperados.getPalabrasEva().equals("1")) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio28" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio28" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva28" rows="3" cols="30"><%=contenidoRecuperados.getObservacion28eva()%></textarea></td>
                        <td><textarea name="observacionConfirma28" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>29. Palabras clave en dos idiomas</td>
                        <%if (contenidoRecuperados.getPalabrasDosIdiomas()) {%>
                        <td><textarea name="preCriterio29" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preCriterio29" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObCriterio29" rows="3" cols="30"><%=contenidoRecuperados.getObservacion29()%></textarea></td>
                            <%if (contenidoRecuperados.getPalabrasDosIdiomasEva().equals("1")) {%>
                            <td><input type="checkbox" name="checkConfirmaCriterio29" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio29" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva29" rows="3" cols="30"><%=contenidoRecuperados.getObservacion29eva()%></textarea></td>
                        <td><textarea name="observacionConfirma29" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>30. Cantidad de artículos publicados por año</td>
                        <td><textarea name="preCriterio30" rows="3" cols="30"/><%=contenidoRecuperados.getCantidadArticulosAnho()%></textarea></td>
                        <td><textarea name="preObCriterio30" rows="3" cols="30"><%=contenidoRecuperados.getObservacion30()%></textarea></td>
                        <td>
                            <label for="publicadosAnho">Cantidad de artículos:</label>
                            <input type="number" id="publicadosAnho" name="publicadosAnho" min="0" max="199" value="<%=contenidoRecuperados.getCantidadArticulosAnhoEva()%>">
                        </td>
                        <td><textarea name="observacionEva30" rows="3" cols="30"><%=contenidoRecuperados.getObservacion30eva()%></textarea></td>
                        <td><textarea name="observacionConfirma30" rows="3" cols="30"></textarea></td>
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