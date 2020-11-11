<%-- 
    Document   : evaUCRIndex
    Created on : 06/05/2020, 01:40:21 PM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.ucrindexEvaluado"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);

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

        public ucrindexEvaluado solicitaPreUCRIndex(String nombreRevista, String organismo) {

            ucrindexEvaluado ucrindexEnSolicitud = new ucrindexEvaluado();

            String consultaSql = "Select preucrindex.mencionMesesPublicacion, preucrindex.miembrosNacionales, preucrindex.miembrosInternacionales,"
                    + " preucrindex.articulosEvaInternos, preucrindex.articulosEvaExternos, preucrindex.diversidadIdioma, preucrindex.documentosNacionales,"
                    + " preucrindex.documentosInternacionales, preucrindex.rigurosos, preucrindex.medianos, preucrindex.poco, preucrindex.noSelectivos, preucrindex.guiaEvaluacion, preucrindex.listaEvaluadores,"
                    + " observacionessolicituducrindex.observacionSolicitudU1, observacionessolicituducrindex.observacionSolicitudU2, observacionessolicituducrindex.observacionSolicitudU3, observacionessolicituducrindex.observacionSolicitudU4,"
                    + " observacionessolicituducrindex.observacionSolicitudU5, observacionessolicituducrindex.observacionSolicitudU6, observacionessolicituducrindex.observacionSolicitudU7, observacionessolicituducrindex.observacionSolicitudU8,"
                    + " observacionessolicituducrindex.observacionSolicitudU9, observacionessolicituducrindex.observacionSolicitudU10, observacionessolicituducrindex.observacionSolicitudU11"
                    + " FROM datosrevista, preucrindex, observacionessolicituducrindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = preucrindex.issnRevista AND datosrevista.issn = observacionessolicituducrindex.issnRevista;";
            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    ucrindexEnSolicitud.setMencionMesesPublicacion(resultado.getString(1));
                    ucrindexEnSolicitud.setMiembrosNacionales(resultado.getInt(2));
                    ucrindexEnSolicitud.setMiembrosInternacionales(resultado.getInt(3));
                    ucrindexEnSolicitud.setArticulosEvaInternos(resultado.getInt(4));
                    ucrindexEnSolicitud.setArticulosEvaExternos(resultado.getInt(5));
                    ucrindexEnSolicitud.setDiversidadIdioma(resultado.getBoolean(6));
                    ucrindexEnSolicitud.setDocumentosNacionales(resultado.getInt(7));
                    ucrindexEnSolicitud.setDocumentosInternacionales(resultado.getInt(8));
                    ucrindexEnSolicitud.setRigurosos(resultado.getInt(9));
                    ucrindexEnSolicitud.setMedianos(resultado.getInt(10));
                    ucrindexEnSolicitud.setPoco(resultado.getInt(11));
                    ucrindexEnSolicitud.setNoSelectivos(resultado.getInt(12));
                    ucrindexEnSolicitud.setGuiaEvaluacion(resultado.getBoolean(13));
                    ucrindexEnSolicitud.setListaEvaluadores(resultado.getBoolean(14));

                    ucrindexEnSolicitud.setObservacionSolicitudU1(resultado.getString(15));
                    ucrindexEnSolicitud.setObservacionSolicitudU2(resultado.getString(16));
                    ucrindexEnSolicitud.setObservacionSolicitudU3(resultado.getString(17));
                    ucrindexEnSolicitud.setObservacionSolicitudU4(resultado.getString(18));
                    ucrindexEnSolicitud.setObservacionSolicitudU5(resultado.getString(19));
                    ucrindexEnSolicitud.setObservacionSolicitudU6(resultado.getString(20));
                    ucrindexEnSolicitud.setObservacionSolicitudU7(resultado.getString(21));
                    ucrindexEnSolicitud.setObservacionSolicitudU8(resultado.getString(22));
                    ucrindexEnSolicitud.setObservacionSolicitudU9(resultado.getString(23));
                    ucrindexEnSolicitud.setObservacionSolicitudU10(resultado.getString(24));
                    ucrindexEnSolicitud.setObservacionSolicitudU11(resultado.getString(25));

                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return ucrindexEnSolicitud;
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
            ucrindexEvaluado ucrindexRecuperado = con.solicitaPreUCRIndex(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("ucrindexRecuperado", ucrindexRecuperado);
        %>

        <h1>Evaluación UCRÍndex</h1>
        <br>
        <form name="evaluacion" action="calculoNotaUCRIndex.jsp" method="POST">
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
                        <td>Cantidad de artículos publicados</td>
                        <td><textarea name="preUcrindex0" rows="3" cols="30"/></textarea></td>
                        <td><textarea name="preObUcrindex0" rows="3" cols="30"></textarea></td>
                        <td>
                            <label for="articulosPublicados">Cantidad de artículos:</label>
                            <input type="number" id="articulosPublicados" name="articulosPublicados" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU0" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>¿Menciona los meses de publicación?</td>
                        <td><textarea name="preUcrindex1" rows="3" cols="30"/><%=ucrindexRecuperado.getMencionMesesPublicacion()%></textarea></td>
                        <td><textarea name="preObUcrindex1" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU1()%></textarea></td>
                        <td><input type="checkbox" id="checkUcrindex1" name="checkUcrindex1" value="ON" /></td>
                        <td><textarea name="observacionEvaU1" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Cuerpo editorial internacional</td>
                        <td><textarea name="preUcrindex2" rows="3" cols="30"/>
                            Miembros Nacionales: <%=ucrindexRecuperado.getMiembrosNacionales()%>
                            Miembros Internacionales:  <%=ucrindexRecuperado.getMiembrosInternacionales()%>
                            </textarea></td>
                        <td><textarea name="preObUcrindex2" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU2()%></textarea></td>
                        <td>
                            <label for="miembrosNacionales">Cantidad de miembros nacionales:</label>
                            <input type="number" id="miembrosNacionales" name="miembrosNacionales" min="0" max="99" value="0">
                            <br><br>
                            <label for="miembrosInternacionales">Cantidad de miembros internacionales:</label>
                            <input type="number" id="miembrosInternacionales" name="miembrosInternacionales" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU2" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Evaluadores externos</td>
                        <td><textarea name="preUcrindex3" rows="3" cols="30"/>
                            Artículos con evaluadores internos: <%=ucrindexRecuperado.getArticulosEvaInternos()%>
                            Artículos con evaluadores externos:  <%=ucrindexRecuperado.getArticulosEvaExternos()%>
                            </textarea></td>
                        <td><textarea name="preObUcrindex3" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU3()%></textarea></td>
                        <td>
                            <label for="evaluadoresInternos">Cantidad de artículos con evaluadores internos:</label>
                            <input type="number" id="evaluadoresInternos" name="evaluadoresInternos" min="0" max="99" value="0">
                            <br><br>
                            <label for="evaluadoresExternos">Cantidad de artículos con evaluadores externos:</label>
                            <input type="number" id="evaluadoresExternos" name="evaluadoresExternos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU3" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Diversidad de idioma</td>
                        <%if (ucrindexRecuperado.getDiversidadIdioma()) {%>
                        <td><textarea name="preUcrindex4" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preUcrindex4" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObUcrindex4" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU4()%></textarea></td>
                        <td><input type="checkbox" id="checkUcrindex4" name="checkUcrindex4" value="ON" /></td>
                        <td><textarea name="observacionEvaU4" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Autores internacionales</td>
                        <td><textarea name="preUcrindex5" rows="3" cols="30"/>
                            Documentos con autores nacionales: <%=ucrindexRecuperado.getDocumentosNacionales()%>
                            Documentos con autores internacionales:  <%=ucrindexRecuperado.getDocumentosInternacionales()%>
                            </textarea></td>
                        <td><textarea name="preObUcrindex5" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU5()%></textarea></td>
                        <td>
                            <label for="documentosNacionales">Cantidad de documentos con autores nacionales:</label>
                            <input type="number" id="documentosNacionales" name="documentosNacionales" min="0" max="99" value="0">
                            <br><br>
                            <label for="documentosInternacionales">Cantidad de documentos con autores internacionales:</label>
                            <input type="number" id="documentosInternacionales" name="documentosInternacionales" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU5" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Índices selectivos rigurosos</td>
                        <td><textarea name="preUcrindex6" rows="3" cols="30"/><%=ucrindexRecuperado.getRigurosos()%></textarea></td>
                        <td><textarea name="preObUcrindex6" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU6()%></textarea></td>
                        <td>
                            <label for="rigurosos">Cantidad de índices rigurosos:</label>
                            <input type="number" id="rigurosos" name="rigurosos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU6" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Índices selectivos medianamente rigurosos</td>
                        <td><textarea name="preUcrindex7" rows="3" cols="30"/><%=ucrindexRecuperado.getMedianos()%></textarea></td>
                        <td><textarea name="preObUcrindex7" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU7()%></textarea></td>
                        <td>
                            <label for="medianos">Cantidad de índices medianamente rigurosos:</label>
                            <input type="number" id="medianos" name="medianos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU7" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Índices selectivos poco rigurosos</td>
                        <td><textarea name="preUcrindex8" rows="3" cols="30"/><%=ucrindexRecuperado.getPoco()%></textarea></td>
                        <td><textarea name="preObUcrindex8" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU8()%></textarea></td>
                        <td>
                            <label for="poco">Cantidad de índices poco rigurosos:</label>
                            <input type="number" id="poco" name="poco" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU8" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Índices no selectivos</td>
                        <td><textarea name="preUcrindex9" rows="3" cols="30"/><%=ucrindexRecuperado.getNoSelectivos()%></textarea></td>
                        <td><textarea name="preObUcrindex9" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU9()%></textarea></td>
                        <td>
                            <label for="noSelectivos">Cantidad de índices no selectivos:</label>
                            <input type="number" id="noSelectivos" name="noSelectivos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionEvaU9" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Guía de evaluación para el arbitraje</td>
                        <%if (ucrindexRecuperado.getGuiaEvaluacion()) {%>
                        <td><textarea name="preUcrindex10" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preUcrindex10" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObUcrindex10" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU10()%></textarea></td>
                        <td><input type="checkbox" id="checkUcrindex10" name="checkUcrindex10" value="ON" /></td>
                        <td><textarea name="observacionEvaU10" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>Lista de evaluadores de la revista</td>
                        <%if (ucrindexRecuperado.getListaEvaluadores()) {%>
                        <td><textarea name="preUcrindex11" rows="3" cols="30"/>Sí cumple</textarea></td>
                        <%} else {%>
                        <td><textarea name="preUcrindex11" rows="3" cols="30"/>No cumple</textarea></td>
                        <%}%>
                        <td><textarea name="preObUcrindex11" rows="3" cols="30"><%=ucrindexRecuperado.getObservacionSolicitudU11()%></textarea></td>
                        <td><input type="checkbox" id="checkUcrindex11" name="checkUcrindex11" value="ON" /></td>
                        <td><textarea name="observacionEvaU11" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>
            <div id="botonSiguiente">
                <input type="submit" value="Calcular UCRIndex" name="enviarUCRIndex"/>
            </div>      
        </form>
    </body>
</html>
