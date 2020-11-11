<%-- 
    Document   : confirmaBasicas
    Created on : 03/08/2020, 09:48:16 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.basicosConfirmados"%>

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

        //Método utilizado para consultar sobre las revistas de la UCR, no recibe nada y retorna el ResultSet
        public ResultSet solicitarNombresDeRevista() {
            String consultaSql = "Select `nombre` From datosrevista;";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            ResultSet resultado = conexion.consultaSQL(consultaSql);	//Se consulta la base de datos

            //Creo que no se cierra la conexión aquí para que los datos sigan disponibles en otras clases
            return resultado;
        }

        public revistaConfirmada obtenerRevistaParaConfirmar(String nombreRevista, String organismo) {

            revistaConfirmada seleccionada = new revistaConfirmada();
            String consultaSql = "Select * FROM datosrevista WHERE datosrevista.estado = 1 AND datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "';";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {

                    seleccionada.setNombre(resultado.getString(1));
                    seleccionada.setOrganismo(resultado.getString(2));
                    seleccionada.setIssn(resultado.getString(3));
                    seleccionada.setFasciculo(resultado.getString(4));
                    seleccionada.setUrl(resultado.getString(5));
                    seleccionada.setSolicitante(resultado.getString(6));
                    seleccionada.setResponsable(resultado.getString(7));
                    seleccionada.setCorreo(resultado.getString(8));
                    seleccionada.setFechaSolicitud(resultado.getString(9));
                    seleccionada.setFechaEvaluacion(resultado.getString(10));
                    seleccionada.setFechaConfirmacion(resultado.getString(11));
                    seleccionada.setEsUCR(resultado.getBoolean(12));
                    seleccionada.setEstado(resultado.getInt(13));
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return seleccionada;
        }

        public basicosConfirmados solicitaEvaBasicos(String nombreRevista, String organismo) {

            basicosConfirmados criteriosBasicos = new basicosConfirmados();

            String consultaSql = "Select criteriosbasicos.responsables, criteriosbasicos.generacionContinua, criteriosbasicos.identificacionAutores,"
                    + " criteriosbasicos.entidadEditora, criteriosbasicos.instruccionesAutores, criteriosbasicos.sistemaArbitraje, criteriosbasicos.issnCriterio,"
                    + "evabasicos.responsables, evabasicos.generacionContinua, evabasicos.identificacionAutores,"
                    + " evabasicos.entidadEditora, evabasicos.instruccionesAutores, evabasicos.sistemaArbitraje, evabasicos.issnCriterio,"
                    + " observacionessolicitudlatindex.observacion1, observacionessolicitudlatindex.observacion2, observacionessolicitudlatindex.observacion3, observacionessolicitudlatindex.observacion4,"
                    + " observacionessolicitudlatindex.observacion5, observacionessolicitudlatindex.observacion6, observacionessolicitudlatindex.observacion7,"
                    + " observacionesevalatindex.observacionEva1, observacionesevalatindex.observacionEva2, observacionesevalatindex.observacionEva3, observacionesevalatindex.observacionEva4,"
                    + " observacionesevalatindex.observacionEva5, observacionesevalatindex.observacionEva6, observacionesevalatindex.observacionEva7"
                    + " FROM datosrevista, criteriosbasicos, evabasicos, observacionessolicitudlatindex, observacionesevalatindex WHERE datosrevista.nombre = '" + nombreRevista + "' AND datosrevista.organismo = '" + organismo + "' AND datosrevista.issn = criteriosbasicos.issnRevista AND datosrevista.issn = evabasicos.issnRevista AND datosrevista.issn = observacionessolicitudlatindex.issnRevista AND datosrevista.issn = observacionesevalatindex.issnRevista;";
            //System.out.println(consultaSql);
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    criteriosBasicos.setResponsables(resultado.getString(1));
                    criteriosBasicos.setGeneracionContinua(resultado.getString(2));
                    criteriosBasicos.setIdAutores(resultado.getString(3));
                    criteriosBasicos.setEntidadEditora(resultado.getString(4));
                    criteriosBasicos.setInstruccionesAutores(resultado.getString(5));
                    criteriosBasicos.setSistemaArbitraje(resultado.getString(6));
                    criteriosBasicos.setIssnCriterio(resultado.getString(7));

                    criteriosBasicos.setResponsablesEva(resultado.getString(8));
                    criteriosBasicos.setGeneracionContinuaEva(resultado.getString(9));
                    criteriosBasicos.setIdAutoresEva(resultado.getString(10));
                    criteriosBasicos.setEntidadEditoraEva(resultado.getString(11));
                    criteriosBasicos.setInstruccionesAutoresEva(resultado.getString(12));
                    criteriosBasicos.setSistemaArbitrajeEva(resultado.getString(13));
                    criteriosBasicos.setIssnCriterioEva(resultado.getString(14));

                    criteriosBasicos.setObservacion1(resultado.getString(15));
                    criteriosBasicos.setObservacion2(resultado.getString(16));
                    criteriosBasicos.setObservacion3(resultado.getString(17));
                    criteriosBasicos.setObservacion4(resultado.getString(18));
                    criteriosBasicos.setObservacion5(resultado.getString(19));
                    criteriosBasicos.setObservacion6(resultado.getString(20));
                    criteriosBasicos.setObservacion7(resultado.getString(21));

                    criteriosBasicos.setObservacion1eva(resultado.getString(22));
                    criteriosBasicos.setObservacion2eva(resultado.getString(23));
                    criteriosBasicos.setObservacion3eva(resultado.getString(24));
                    criteriosBasicos.setObservacion4eva(resultado.getString(25));
                    criteriosBasicos.setObservacion5eva(resultado.getString(26));
                    criteriosBasicos.setObservacion6eva(resultado.getString(27));
                    criteriosBasicos.setObservacion7eva(resultado.getString(28));

                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return criteriosBasicos;
        }
    }


%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Confirmar</title>
    </head>
    <body>

        <%
            request.setCharacterEncoding("UTF-8");
            String revistaAConfirmar = request.getParameter("nombreConsultado");
            String organismoAConfirmar = request.getParameter("organismoConsultado");
            conexionBD con = new conexionBD();
            HttpSession misession = request.getSession(true);
            revistaConfirmada revistaRecuperada = con.obtenerRevistaParaConfirmar(revistaAConfirmar, organismoAConfirmar);
            basicosConfirmados basicosRecuperados = con.solicitaEvaBasicos(revistaRecuperada.getNombre(), revistaRecuperada.getOrganismo());
            misession.setAttribute("revistaRecuperada", revistaRecuperada);
            misession.setAttribute("basicosRecuperados", basicosRecuperados);

        %>

        <h1>Evaluación Latindex</h1><button type="button" name="back" onclick="history.back()">Volver</button> 
        <br>
        <form name="confirmacion" action="confirmaPresentacion.jsp" method="POST">
            <h3>Datos de la Revista</h3>
            <table border="0">
                <tbody>
                    <tr>
                        <td>Revista evaluada:</td>
                        <td><input type="text" name="textRevistaEvaluada" disabled="disabled" size="80" value="<%= revistaRecuperada.getNombre()%>" /></td>
                    </tr>
                    <tr>
                        <td>ISSN:</td>
                        <td><input type="text" name="issn" disabled="disabled" value="<%= revistaRecuperada.getIssn()%>"/></td>
                    </tr>
                    <tr>
                        <td>Fascículo evaluado:</td>
                        <td><input type="text" id="textFasciculoEvaluado" name="textFasciculoEvaluado" size="80" value="<%= revistaRecuperada.getFasciculo()%>" /></td>
                    </tr>
                    <tr>
                        <td>Evaluador</td>
                        <td><input type="text" name="textEvaluador" size="50" value="<%= misession.getAttribute("username")%>" /></td>
                    </tr>
                    <tr>
                        <td>Procedencia:</td>
                        <td><input type="text" name="textProcedencia" disabled="disabled" size="80" value="<%= revistaRecuperada.getOrganismo()%>" /></td>
                    </tr>
                    <!--tr>
                        <td>Periodicidad:</td>
                        <td>
                            <select name="comboPeriodicidad">
                                <option value="Mensual">Mensual</option>
                                <option value="Bimensual">Bimensual</option>
                                <option value="Trimestral">Trimestral</option>
                                <option value="Cuatrimestral">Cuatrimestral</option>
                                <option value="Semestral">Semestral</option>
                                <option value="Anual">Anual</option>
                                <option value="Bienal">Bienal</option>
                            </select>
                        </td>
                    </tr-->
                    <tr>
                        <td>Fecha de solicitud:</td>
                        <td><input type="text" name="textFechaSolicitud" disabled="disabled" value="<%= revistaRecuperada.getFechaSolicitud()%>" /></td>
                    </tr>
                    <tr>
                        <td>Fecha de evaluación:</td>
                        <td><input type="text" name="textFechaEvaluacion" disabled="disabled" value="<%= revistaRecuperada.getFechaEvaluacion()%>" /></td>
                    </tr>
                    <tr>
                        <td>Fecha de confirmación:</td>
                        <%
                            String fechaHoy = new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date());
                        %>
                        <td><input type="text" name="textFechaConfirmacion" value="<%= fechaHoy%>" disabled="disabled" /></td>
                    </tr>
                </tbody>
            </table>
            <h3>Criterios Básicos</h3>
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
                        <td>1. Responsables editoriales</td>
                        <td><textarea name="preCriterio1" rows="3" cols="30"/><%=basicosRecuperados.getResponsables()%></textarea></td>
                        <td><textarea name="preObCriterio1" rows="3" cols="30"><%=basicosRecuperados.getObservacion1()%></textarea></td>
                            <%if ((basicosRecuperados.getResponsablesEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio1" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio1" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva1" rows="3" cols="30"><%=basicosRecuperados.getObservacion1eva()%></textarea></td>
                        <td><textarea name="observacionConfirma1" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>2. Generación contínua de contenidos</td>
                        <td><textarea name="preCriterio2" rows="3" cols="30"/><%=basicosRecuperados.getGeneracionContinua()%></textarea></td>
                        <td><textarea name="preObCriterio2" rows="3" cols="30"><%=basicosRecuperados.getObservacion2()%></textarea></td>
                            <%if ((basicosRecuperados.getGeneracionContinuaEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio2" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio2" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva2" rows="3" cols="30"><%=basicosRecuperados.getObservacion2eva()%></textarea></td>
                        <td><textarea name="observacionConfirma2" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>3. Identificación de los autores</td>
                        <td><textarea name="preCriterio3" rows="3" cols="30"/><%=basicosRecuperados.getIdAutores()%></textarea></td>
                        <td><textarea name="preObCriterio3" rows="3" cols="30"><%=basicosRecuperados.getObservacion3()%></textarea></td>
                        <%if ((basicosRecuperados.getIdAutoresEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio3" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio3" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva3" rows="3" cols="30"><%=basicosRecuperados.getObservacion3eva()%></textarea></td>
                        <td><textarea name="observacionConfirma3" rows="3" cols="30"></textarea></td>

                    </tr>
                    <tr>
                        <td>4. Entidad editora de la revista</td>
                        <td><textarea name="preCriterio4" rows="3" cols="30"/><%=basicosRecuperados.getEntidadEditora()%></textarea></td>
                        <td><textarea name="preObCriterio4" rows="3" cols="30"><%=basicosRecuperados.getObservacion4()%></textarea></td>
                        <%if ((basicosRecuperados.getEntidadEditoraEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio4" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio4" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva4" rows="3" cols="30"><%=basicosRecuperados.getObservacion4eva()%></textarea></td>
                        <td><textarea name="observacionConfirma4" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>5. Instrucciones a los autores</td>
                        <td><textarea name="preCriterio5" rows="3" cols="30"/><%=basicosRecuperados.getInstruccionesAutores()%></textarea></td>
                        <td><textarea name="preObCriterio5" rows="3" cols="30"><%=basicosRecuperados.getObservacion5()%></textarea></td>
                        <%if ((basicosRecuperados.getInstruccionesAutoresEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio5" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio5" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva5" rows="3" cols="30"><%=basicosRecuperados.getObservacion5eva()%></textarea></td>
                        <td><textarea name="observacionConfirma5" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>6. Sistema de arbitraje</td>
                        <td><textarea name="preCriterio6" rows="3" cols="30"/><%=basicosRecuperados.getSistemaArbitraje()%></textarea></td>
                        <td><textarea name="preObCriterio6" rows="3" cols="30"><%=basicosRecuperados.getObservacion6()%></textarea></td>
                        <%if ((basicosRecuperados.getSistemaArbitrajeEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio6" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio6" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva6" rows="3" cols="30"><%=basicosRecuperados.getObservacion6eva()%></textarea></td>
                        <td><textarea name="observacionConfirma6" rows="3" cols="30"></textarea></td>
                    </tr>
                    <tr>
                        <td>7. ISSN</td>
                        <td><textarea name="preCriterio7" rows="3" cols="30"/><%=basicosRecuperados.getIssnCriterio()%></textarea></td>
                        <td><textarea name="preObCriterio7" rows="3" cols="30"><%=basicosRecuperados.getObservacion7()%></textarea></td>
                        <%if ((basicosRecuperados.getIssnCriterioEva().equals("Sí cumple"))) {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio7" value="ON" checked="checked"/></td>
                            <%} else {%>
                        <td><input type="checkbox" name="checkConfirmaCriterio7" value="ON" /></td>
                            <%}%>
                        <td><textarea name="observacionEva7" rows="3" cols="30"><%=basicosRecuperados.getObservacion7eva()%></textarea></td>
                        <td><textarea name="observacionConfirma7" rows="3" cols="30"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>          
            <div id="botonSiguiente">
                <button type="button" name="back" onclick="history.back()">ATRÁS</button>
                <input type="submit" value="SIGUIENTE" name="enviarBasicas" onclick="javascript:return checkValidation()"/>
            </div>      

            <script type="text/javascript">
                function checkValidation() {
                    if (document.getElementById('textFasciculoEvaluado').value === "") {
                        alert("Por favor indique el fascículo evaluado");
                        return false;
                    }
                }
            </script>

        </form>
    </body>
</html>

