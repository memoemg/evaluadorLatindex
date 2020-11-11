<%-- 
    Document   : guardarLatindex
    Created on : 04/05/2020, 09:31:17 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ucrindex.revistaEvaluada"%>
<%@page import="ucrindex.basicosEvaluados"%>
<%@page import="ucrindex.gestionEvaluados"%>
<%@page import="ucrindex.enLineaEvaluados"%>
<%@page import="ucrindex.contenidoEvaluados"%>
<%@page import="ucrindex.presentacionEvaluados"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"  %>
<%@page import="java.sql.*"%>


<% Class.forName("com.mysql.jdbc.Driver"); 

double notaLatindex = (Double.parseDouble(request.getParameter("notaLatindex")));
String indexada = request.getParameter("indexada");

%>

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
            conn = null;
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

        //Método utilizado para ingresar una revista a la base de datos, recibe un objeto revista y retorna un entero
        //El entero retornado corresponde al que devuelve operacionSQL
        public int actualizarDatosRevista(String issn, String fasciculo, String fechaEvaluacion, int estado) {
            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "UPDATE `datosrevista` SET `fasciculo` = '"+fasciculo+"', `fechaEvaluacion` = '"+fechaEvaluacion+"', `estado`= "+estado+" WHERE `datosrevista`.issn = '"+issn+"';";

            //System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaBasicos(String issnRevista, String responsables, String generacionContinua,
                String identificacionAutores, String entidadEditora, String instruccionesAutores, String sistemaArbitraje,
                String issnCriterio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evabasicos`(`issnRevista`, `responsables`, `generacionContinua`, `identificacionAutores`, `entidadEditora`, `instruccionesAutores`, `sistemaArbitraje`, `issnCriterio`) VALUES ('" + issnRevista + "', '" + responsables + "', '" + generacionContinua + "', '" + identificacionAutores + "', '" + entidadEditora + "', '" + instruccionesAutores + "', '" + sistemaArbitraje + "', '" + issnCriterio + "');";
            //System.out.println(consultaSql);

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaGestion(String issnRevista, String definicionRevista, int autoresExternos, int autoresInternos, int miembrosInternos, int miembrosExternos, String serviciosInformacion, String cumplimientoPeriodicidad, String politicaAccesoReuso, String codigoEtica, String deteccionPlagio) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evagestion`(`issnRevista`, `definicionRevista`, `autoresExternos`, `autoresInternos`, `miembrosInternos`, `miembrosExternos`, `serviciosInformacion`, `cumplimientoPeriodicidad`, `politicaAccesoReuso`, `codigoEtica`, `deteccionPlagio`) VALUES ('" + issnRevista + "', '" + definicionRevista + "', " + autoresExternos + ", " + autoresInternos + ", " + miembrosInternos + ", " + miembrosExternos + ", '" + serviciosInformacion + "', '" + cumplimientoPeriodicidad + "', '" + politicaAccesoReuso + "', '" + codigoEtica + "', '" + deteccionPlagio + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaEnLinea(String issnRevista, String interoperabilidad, boolean formatosEdicion, String valorAgregado, String interactividad, String buscadores, boolean identificadoresDeRecurso, String estadisticas, String politicaPreservacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evaenlinea`(`issnRevista`, `interoperabilidad`, `formatosEdicion`, `valorAgregado`, `interactividad`, `buscadores`, `identificadoresDeRecurso`, `estadisticas`, `politicaPreservacion`) VALUES ('" + issnRevista + "', '" + interoperabilidad + "', " + formatosEdicion + ", '" + valorAgregado + "', '" + interactividad + "', '" + buscadores + "', " + identificadoresDeRecurso + ", '" + estadisticas + "', '" + politicaPreservacion + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaContenido(String issnRevista, int documentosOriginales, int otrosTipos, String referenciasBibliograficas, String exigenciaOriginalidad, boolean resumen, boolean resumenDosIdiomas, boolean palabras, boolean palabrasDosIdiomas, int cantidadArticulosAnho) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evacontenido`(`issnRevista`, `documentosOriginales`, `otrosTipos`, `referenciasBibliograficas`, `exigenciaOriginalidad`, `resumen`, `resumenDosIdiomas`, `palabras`, `palabrasDosIdiomas`, `cantidadArticulosAnho`) VALUES ('" + issnRevista + "', " + documentosOriginales + ", " + otrosTipos + ", '" + referenciasBibliograficas + "', '" + exigenciaOriginalidad + "', " + resumen + ", " + resumenDosIdiomas + ", " + palabras + ", " + palabrasDosIdiomas + ", " + cantidadArticulosAnho + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarEvaPresentacion(String issnRevista, boolean navegacion, boolean accesoHistorico, String mencionPeriodicidad, boolean membreteInicio, String afiliacionCuerposEditoriales, boolean afiliacionAutores, boolean fechasRecepcionAceptacion) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `evapresentacion`(`issnRevista`, `navegacion`, `accesoHistorico`, `mencionPeriodicidad`, `membreteInicio`, `afiliacionCuerposEditoriales`, `afiliacionAutores`, `fechasRecepcionAceptacion`) VALUES ('" + issnRevista + "', " + navegacion + ", " + accesoHistorico + ", '" + mencionPeriodicidad + "', " + membreteInicio + ", '" + afiliacionCuerposEditoriales + "', " + afiliacionAutores + ", " + fechasRecepcionAceptacion + ");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarNotaLatindex(String issnRevista, double notaLatindex, double notaUCRIndex, boolean indexada) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `notas`(`issnRevista`, `notaLatindex`, `notaUcrindex`, `indexada`) VALUES ('" + issnRevista + "', " + notaLatindex + ", " + notaUCRIndex+ ", "+indexada+");";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }

        public int insertarObservacionesEvaluacion(String issnRevista, String observacion1, String observacion2, String observacion3, String observacion4, String observacion5, String observacion6, String observacion7, String observacion8, String observacion9, String observacion10, String observacion11, String observacion12, String observacion13, String observacion14, String observacion15,
                String observacion16, String observacion17, String observacion18, String observacion19, String observacion20, String observacion21, String observacion22, String observacion23, String observacion24, String observacion25, String observacion26, String observacion27, String observacion28, String observacion29, String observacion30, String observacion31, String observacion32, String observacion33,
                String observacion34, String observacion35, String observacion36, String observacion37, String observacion38) {

            //Creación de la sentencia SQL para insertar los datos de la revista en la tabla revista
            String consultaSql = "INSERT INTO `observacionesevalatindex`(`issnrevista`, `observacionEva1`, `observacionEva2`, `observacionEva3`, `observacionEva4`, `observacionEva5`, `observacionEva6`, `observacionEva7`, `observacionEva8`, `observacionEva9`, `observacionEva10`, `observacionEva11`,"
                    + " `observacionEva12`, `observacionEva13`, `observacionEva14`, `observacionEva15`, `observacionEva16`, `observacionEva17`, `observacionEva18`, `observacionEva19`, `observacionEva20`, `observacionEva21`, `observacionEva22`, `observacionEva23`, `observacionEva24`, `observacionEva25`, `observacionEva26`, `observacionEva27`, `observacionEva28`,"
                    + " `observacionEva29`, `observacionEva30`, `observacionEva31`, `observacionEva32`, `observacionEva33`, `observacionEva34`, `observacionEva35`, `observacionEva36`, `observacionEva37`, `observacionEva38`) VALUES ('" + issnRevista + "', '" + observacion1 + "', '" + observacion2 + "', '" + observacion3 + "', '" + observacion4 + "', '" + observacion5 + "', '" + observacion6 + "', '" + observacion7 + "', '" + observacion8 + "', '" + observacion9 + "', '" + observacion10
                    + "', '" + observacion11 + "', '" + observacion12 + "', '" + observacion13 + "', '" + observacion14 + "', '" + observacion15 + "', '" + observacion16 + "', '" + observacion17 + "', '" + observacion18 + "', '" + observacion19 + "', '" + observacion20 + "', '" + observacion21 + "', '" + observacion22 + "', '" + observacion23 + "', '" + observacion24 + "', '" + observacion25 + "', '" + observacion26 + "', '" + observacion27 + "', '" + observacion28 + "', '" + observacion29 + "', '" + observacion30 + "', '" + observacion31 + "', '" + observacion32 + "', '" + observacion33
                    + "', '" + observacion34 + "', '" + observacion35 + "', '" + observacion36 + "', '" + observacion37 + "', '" + observacion38 + "');";

            conexionBD conexion = new conexionBD();  //Se instancia la conexión
            conexion.abrirConexion();	//Se abre
            int resultado = conexion.operacionSQL(consultaSql);	//Se ejecuta la operación
            conexion.cerrarConexion();	//Se cierra la conexión
            return resultado;
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <div class="container">
        <%
            request.setCharacterEncoding("UTF-8");

            HttpSession misession = request.getSession(true);
            revistaEvaluada revistaRecuperada = (revistaEvaluada) misession.getAttribute("revistaRecuperada");
            revistaRecuperada.setEstado(1); //0 significa sin evaluar, 1 evaluada, 2 confirmada
            String fechaHoy = new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date());
            revistaRecuperada.setFechaEvaluacion(fechaHoy);
            conexionBD con = new conexionBD();

            con.actualizarDatosRevista(revistaRecuperada.getIssn(), revistaRecuperada.getFasciculo(), revistaRecuperada.getFechaEvaluacion(), revistaRecuperada.getEstado());

            basicosEvaluados basicosRecuperados = (basicosEvaluados) misession.getAttribute("basicosRecuperados");
            con.insertarEvaBasicos(revistaRecuperada.getIssn(), basicosRecuperados.getResponsables(), basicosRecuperados.getGeneracionContinua(), basicosRecuperados.getIdAutores(), basicosRecuperados.getEntidadEditora(), basicosRecuperados.getInstruccionesAutores(), basicosRecuperados.getSistemaArbitraje(), basicosRecuperados.getIssnCriterio());

            contenidoEvaluados contenidoRecuperados = (contenidoEvaluados) misession.getAttribute("contenidoRecuperados");
            con.insertarEvaContenido(revistaRecuperada.getIssn(), contenidoRecuperados.getDocumentosOriginales(), contenidoRecuperados.getOtroTipo(), contenidoRecuperados.getReferenciasBibliograficas(), contenidoRecuperados.getExigenciaOriginalidad(), contenidoRecuperados.getResumen(), contenidoRecuperados.getResumenDosIdiomas(), contenidoRecuperados.getPalabras(), contenidoRecuperados.getPalabrasDosIdiomas(), contenidoRecuperados.getCantidadArticulosAnho());

            enLineaEvaluados enLineaRecuperados = (enLineaEvaluados) misession.getAttribute("enLineaRecuperados");
            con.insertarEvaEnLinea(revistaRecuperada.getIssn(), enLineaRecuperados.getInteroperabilidad(), enLineaRecuperados.getFormatosEdicion(), enLineaRecuperados.getValorAgregado(), enLineaRecuperados.getInteractividad(), enLineaRecuperados.getBuscadores(), enLineaRecuperados.getIdentificadoresDeRecurso(), enLineaRecuperados.getEstadisticas(), enLineaRecuperados.getPoliticaPreservacion());

            presentacionEvaluados presentacionRecuperados = (presentacionEvaluados) misession.getAttribute("presentacionRecuperados");
            con.insertarEvaPresentacion(revistaRecuperada.getIssn(), presentacionRecuperados.getNavegacion(), presentacionRecuperados.getAccesoHistorico(), presentacionRecuperados.getMencionPeriodicidad(), presentacionRecuperados.getMembreteInicio(), presentacionRecuperados.getAfiliacionCuerposEditoriales(), presentacionRecuperados.getAfiliacionAutores(), presentacionRecuperados.getFechasRecepcionAceptacion());

            gestionEvaluados gestionRecuperados = (gestionEvaluados) misession.getAttribute("gestionRecuperados");
            con.insertarEvaGestion(revistaRecuperada.getIssn(), gestionRecuperados.getDefinicionRevista(), gestionRecuperados.getAutoresExternos(), gestionRecuperados.getAutoresInternos(), gestionRecuperados.getMiembrosInternos(), gestionRecuperados.getMiembrosExternos(), gestionRecuperados.getServiciosInformacion(), gestionRecuperados.getCumplimientoPeriodicidad(), gestionRecuperados.getPoliticaAccesoReuso(), gestionRecuperados.getCodigoEtica(), gestionRecuperados.getDeteccionPlagio());
            
            boolean indexBD = true;
            if(indexada.equals("NO"))
            {
                indexBD = false;
            }
            
            con.insertarNotaLatindex(revistaRecuperada.getIssn(), notaLatindex, 0.0000, indexBD);

            //insertar observacionesPreevaluacion
            con.insertarObservacionesEvaluacion(revistaRecuperada.getIssn(), basicosRecuperados.getObservacion1(), basicosRecuperados.getObservacion2(), basicosRecuperados.getObservacion3(), basicosRecuperados.getObservacion4(), basicosRecuperados.getObservacion5(), basicosRecuperados.getObservacion6(), basicosRecuperados.getObservacion7(),
                    presentacionRecuperados.getObservacion8(), presentacionRecuperados.getObservacion9(), presentacionRecuperados.getObservacion10(), presentacionRecuperados.getObservacion11(), presentacionRecuperados.getObservacion12(), presentacionRecuperados.getObservacion13(), presentacionRecuperados.getObservacion14(),
                    gestionRecuperados.getObservacion15(), gestionRecuperados.getObservacion16(), gestionRecuperados.getObservacion17(), gestionRecuperados.getObservacion18(), gestionRecuperados.getObservacion19(), gestionRecuperados.getObservacion20(), gestionRecuperados.getObservacion21(), gestionRecuperados.getObservacion22(),
                    contenidoRecuperados.getObservacion23(), contenidoRecuperados.getObservacion24(), contenidoRecuperados.getObservacion25(), contenidoRecuperados.getObservacion26(), contenidoRecuperados.getObservacion27(), contenidoRecuperados.getObservacion28(), contenidoRecuperados.getObservacion29(), contenidoRecuperados.getObservacion30(),
                    enLineaRecuperados.getObservacion31(), enLineaRecuperados.getObservacion32(), enLineaRecuperados.getObservacion33(), enLineaRecuperados.getObservacion34(), enLineaRecuperados.getObservacion35(), enLineaRecuperados.getObservacion36(), enLineaRecuperados.getObservacion37(), enLineaRecuperados.getObservacion38());
            
            misession.setAttribute("revistaRecuperada", revistaRecuperada);
            
            if(revistaRecuperada.getEsUCR())
            {
                response.sendRedirect("evaUCRIndex.jsp");
            }
            else
            {
                response.sendRedirect("tabla.jsp");
            }

        %>

    </body>
</html>
