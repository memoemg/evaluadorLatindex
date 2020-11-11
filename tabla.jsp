<%-- 
    Document   : tabla
    Created on : 27/04/2020, 09:24:33 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>

<% Class.forName("com.mysql.jdbc.Driver"); %>

<%
    HttpSession misession = request.getSession(true);
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

        public ArrayList<String> solicitarRevistasNoEvaluadas(String usuarioLogueado) {

            ArrayList<String> noEvaluadas = new ArrayList<>();
            String consultaSql = "";

            if (usuarioLogueado.equals("ucrindex")) {
                consultaSql = "SELECT `nombre`, `organismo`, `url`, `evaluador`, `fechaSolicitud` FROM `datosrevista`, `evaluadores`  WHERE `estado` = 0 AND `datosrevista`.issn = `evaluadores`.issnRevista ORDER BY consecutivo ASC;";
            } else {
                consultaSql = "SELECT `nombre`, `organismo`, `url` FROM `datosrevista`, `evaluadores`  WHERE `estado` = 0 AND `datosrevista`.issn = `evaluadores`.issnRevista AND `evaluadores`.evaluador = '" + usuarioLogueado + "';";
            }

            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    String nombre = resultado.getString(1);
                    String organismo = resultado.getString(2);
                    String url = resultado.getString(3);
                    String recuperada = nombre + "@" + organismo + "@" + url;
                    if (usuarioLogueado.equals("ucrindex")) {
                        String evaluador = resultado.getString(4);
                        String fechaSolicitud = resultado.getString(5);
                        recuperada += "@" + evaluador + "@" + fechaSolicitud;
                    }

                    noEvaluadas.add(recuperada);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return noEvaluadas;

        }

        public ArrayList<String> solicitarRevistasEvaluadas(String usuarioLogueado) {
            ArrayList<String> evaluadas = new ArrayList<>();
            String consultaSql = "";
            if (usuarioLogueado.equals("ucrindex")) {
                consultaSql = "SELECT `nombre`, `organismo`, `url`, `notaLatindex`, `notaUCRIndex`, `evaluador`, `fechaSolicitud`, `fechaEvaluacion` FROM `datosrevista`, `evaluadores`, `notas`  WHERE `estado` = 1 AND `datosrevista`.issn = `evaluadores`.issnRevista AND `datosrevista`.issn = `notas`.issnRevista ORDER BY consecutivo ASC;";
            } else {
                consultaSql = "SELECT `nombre`, `organismo`, `url`, `notaLatindex`, `notaUCRIndex` FROM `datosrevista`, `evaluadores`, `notas` WHERE `estado` = 1 AND `datosrevista`.issn = `evaluadores`.issnRevista AND `datosrevista`.issn = `notas`.issnRevista AND `evaluadores`.evaluador = '" + usuarioLogueado + "';";
            }

            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    String nombre = resultado.getString(1);
                    String organismo = resultado.getString(2);
                    String url = resultado.getString(3);
                    String posibleLatindex = resultado.getString(4);
                    String posibleUCRIndex = resultado.getString(5);
                    String recuperada = nombre + "@" + organismo + "@" + url + "@" + posibleLatindex + "@" + posibleUCRIndex;
                    if (usuarioLogueado.equals("ucrindex")) {
                        String evaluador = resultado.getString(6);
                        String fechaSolicitud = resultado.getString(7);
                        String fechaEvaluacion = resultado.getString(8);
                        recuperada += "@" + evaluador + "@" + fechaSolicitud + "@" + fechaEvaluacion;
                    }
                    evaluadas.add(recuperada);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return evaluadas;

        }

        public ArrayList<String> solicitarRevistasInconclusas() {
            ArrayList<String> inconclusas = new ArrayList<>();
            /*String consultaSql = "Select nombre, organismo, url, notaLatindex, notaCONARE From datosrevista, notas Where estado=3 AND datosrevista.issn = notas.issnRC;";

            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    String nombre = resultado.getString(1);
                    String organismo = resultado.getString(2);
                    String url = resultado.getString(3);
                    String posibleLatindex = resultado.getString(4);
                    String posibleCONARE = resultado.getString(5);
                    String recuperada = nombre + "@" + organismo + "@" + url + "@" + posibleLatindex + "@" + posibleCONARE;
                    inconclusas.add(recuperada);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }*/

            return inconclusas;

        }

        public ArrayList<String> solicitarRevistasConfirmadas() {
            ArrayList<String> confirmadas = new ArrayList<>();
            //String consultaSql = "Select nombre, organismo, notaLatindex, notaCONARE From datosrevista, notas Where estado=2 AND datosrevista.issn = notas.issnRC;";
            String consultaSql = "SELECT `nombre`, `organismo`, `url`, `notaLatindex`, `notaUCRIndex`, `fechaSolicitud`, `fechaEvaluacion`, `fechaConfirmacion` FROM `datosrevista`, `notas`  WHERE `estado` = 2 AND `datosrevista`.issn = `notas`.issnRevista ORDER BY consecutivo ASC;";
            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                while (resultado.next()) {
                    String nombre = resultado.getString(1);
                    String organismo = resultado.getString(2);
                    String url = resultado.getString(3);
                    String latindex = resultado.getString(4);
                    String ucrindex = resultado.getString(5);
                    String fechaSolicitud = resultado.getString(6);
                    String fechaEvaluacion = resultado.getString(7);
                    String fechaConfirmacion = resultado.getString(8);
                    String confirmada = nombre + "@" + organismo + "@" + url + "@" + latindex + "@" + ucrindex + "@" + fechaSolicitud + "@" + fechaEvaluacion + "@" + fechaConfirmacion;
                    confirmadas.add(confirmada);
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return confirmadas;

        }

    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <body>

        <form name="tabla1" action="evaBasicas.jsp" method="POST">

            <style>
                table tr
                {
                    cursor: pointer;
                    transition: all .25s ease-in-out;
                }
                table tr:hover{
                    background-color: #ddd;
                }
            </style>

            <h2>Revistas disponibles para evaluación</h2>
            <table id="sinEvaluar" border="1">
                <thead>
                    <tr>
                        <th>Nombre de Revista</th>
                        <th>Organismo responsable</th>
                        <th>URL</th>
                            <%
                                conexionBD con = new conexionBD();
                                String usuarioLogueado = misession.getAttribute("username").toString();

                                if (usuarioLogueado.equals("ucrindex")) {
                            %>
                        <th>Evaluador asignado</th>
                        <th>Fecha de solicitud</th>
                            <%  }
                            %>
                    </tr>
                </thead>    
                <tbody> 
                    <%
                        ArrayList<String> noEvaluadas = con.solicitarRevistasNoEvaluadas(usuarioLogueado);
                        int contador = 1;

                        for (int i = 0; i < noEvaluadas.size(); i++) {%>
                    <tr>
                        <td><%= noEvaluadas.get(i).split("@")[0]%></td> 
                        <td><%= noEvaluadas.get(i).split("@")[1]%></td>
                        <!--<td><%= noEvaluadas.get(i).split("@")[2]%></td>-->
                        <td><a href="<%= noEvaluadas.get(i).split("@")[2]%>" target="_blank"><%=noEvaluadas.get(i).split("@")[2]%></a></td>
                            <%if (usuarioLogueado.equals("ucrindex")) {
                            %>
                        <td><%= noEvaluadas.get(i).split("@")[3]%></td>
                        <td><%= noEvaluadas.get(i).split("@")[4]%></td>
                        <%  }
                        %>
                        
                        <td><input type="radio" name="rdbtnevaluar" id="boton<%= contador%>" value="" /></td>
                         
                    </tr>
                    <%contador++;
                        }%>
                </tbody>
            </table>  

            <input type="hidden" id="nombreSeleccionado" name="nombreSeleccionado" value="" />
            <input type="hidden" id="organismoSeleccionado" name="organismoSeleccionado" value="" />
            <br>
            <input type="submit" value="EVALUAR REVISTA" name="btnEvaluar" onclick="javascript:return checkValidation()"/>

            <script type="text/javascript">
                function checkValidation() {
                    if (document.getElementById('nombreSeleccionado').value === "") {
                        alert("Por favor seleccione una revista para su evaluación");
                        return false;
                    }
                }
            </script>

            <script>
                var table = document.getElementById('sinEvaluar');
                for (var i = 1; i < table.rows.length; i++)
                {
                    table.rows[i].onclick = function ()
                    {
                        //rIndex = this.rowsIndex;
                        document.getElementById("nombreSeleccionado").value = this.cells[0].innerHTML;
                        document.getElementById("organismoSeleccionado").value = this.cells[1].innerHTML;
                    };
                }
            </script>

        </form>

        <h2>Revistas evaluadas</h2>

        <form name="tabla2" action="confirmaBasicas.jsp" method="POST">
            <table id="evaluadas" border="1">
                <thead>
                    <tr>
                        <th>Nombre de Revista</th>
                        <th>Organismo responsable</th>
                        <th>URL</th>
                        <th>Posible Nota Latindex</th>
                        <th>Posible Nota UCRIndex</th>

                        <%if (usuarioLogueado.equals("ucrindex")) {
                        %>
                        <th>Evaluada por</th>
                        <th>Fecha de solicitud</th>
                        <th>Fecha de evaluación</th>
                            <%}%>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ArrayList<String> evaluadas = con.solicitarRevistasEvaluadas(usuarioLogueado);
                        int contador2 = 1;

                        for (int i = 0; i < evaluadas.size(); i++) {%>
                    <tr>
                        <td><%= evaluadas.get(i).split("@")[0]%></td> 
                        <td><%= evaluadas.get(i).split("@")[1]%></td>
                        <td><%= evaluadas.get(i).split("@")[2]%></td>
                        <td><%= evaluadas.get(i).split("@")[3]%></td>
                        <td><%= evaluadas.get(i).split("@")[4]%></td>
                        <!--<td><a href="<%= evaluadas.get(i).split("@")[2]%>"><%=evaluadas.get(0).split("@")[2]%></a></td>-->
                        <%if (usuarioLogueado.equals("ucrindex")) {
                        %>
                        <td><%= evaluadas.get(i).split("@")[5]%></td>
                        <td><%= evaluadas.get(i).split("@")[6]%></td>
                        <td><%= evaluadas.get(i).split("@")[7]%></td>
                        <%}%>
                        
                        <td><input type="radio" name="rdbtnconsultar" id="boton<%= contador2%>" value="" /></td>
                            
                    </tr>
                    <%contador2++;
                        }%>
                </tbody>
            </table>
            <br><input type="submit" value="CONFIRMAR EVALUACIÓN" name="btnConfirmar" onclick="javascript:return confirmaValidation()"/>

            <input type="hidden" id="nombreConsultado" name="nombreConsultado" value="" />
            <input type="hidden" id="organismoConsultado" name="organismoConsultado" value="" />

            <script>
                var table = document.getElementById('evaluadas');
                for (var i = 1; i < table.rows.length; i++)
                {
                    table.rows[i].onclick = function ()
                    {
                        //rIndex = this.rowsIndex;
                        document.getElementById("nombreConsultado").value = this.cells[0].innerHTML;
                        document.getElementById("organismoConsultado").value = this.cells[1].innerHTML;
                    };
                }
            </script>

            <script type="text/javascript">
                function confirmaValidation() {
                    if (document.getElementById('nombreConsultado').value === "") {
                        alert("Por favor seleccione una revista para su confirmación");
                        return false;
                    }
                }
            </script>  
        </form>

        <h2>Evaluaciones confirmadas</h2>
        <table id="confirmadas" border="1">
            <thead>
                <tr>
                    <th>Nombre de Revista</th>
                    <th>Organismo responsable</th>
                    <th>URL</th>
                    <th>Nota Latindex</th>
                    <th>Nota UCRIndex</th>
                    <th>Fecha Solicitud</th>
                    <th>Fecha Evaluación</th>
                    <th>Fecha Confirmación</th>
                </tr>
            </thead>    
            <tbody>
                <%
                    ArrayList<String> confirmadas = con.solicitarRevistasConfirmadas();
                    int contador3 = 1;

                    for (int i = 0;
                            i < confirmadas.size();
                            i++) {%>
                <tr>
                    <td><%= confirmadas.get(i).split("@")[0]%></td> 
                    <td><%= confirmadas.get(i).split("@")[1]%></td>
                    <td><%= confirmadas.get(i).split("@")[2]%></td>
                    <td><%= confirmadas.get(i).split("@")[3]%></td>
                    <td><%= confirmadas.get(i).split("@")[4]%></td>
                    <td><%= confirmadas.get(i).split("@")[5]%></td>
                    <td><%= confirmadas.get(i).split("@")[6]%></td>
                    <td><%= confirmadas.get(i).split("@")[7]%></td>
                </tr>
                <%contador3++;
                    }%>
            </tbody>
        </table>
        <br><input type="submit" value="Volver a Inicio" onclick="window.location = 'index.jsp';" />

    </body>
</html>
