<%-- 
    Document   : loginCheck
    Created on : 27/04/2020, 09:26:03 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>

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

        public boolean logueo(String usuario, String contraseña) {

            String consultaSql = "Select usuario, contraseña FROM usuarios Where usuario='" + usuario + "' AND contraseña='" + contraseña + "';";

            conexionBD conexion = new conexionBD();
            conexion.abrirConexion();
            ResultSet resultado = conexion.consultaSQL(consultaSql);

            try {
                if (resultado.next()) {
                    return true;
                }

            } catch (SQLException e) {
                System.out.println("Entré en el catch");
            }

            return false;

        }
    }
%>

<!DOCTYPE html>
<html> 
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
    </head> 
    <body> 
        <%
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            conexionBD con = new conexionBD();
            con.abrirConexion();

            if (con.logueo(username, password)) {
                HttpSession misession = request.getSession(true);
                misession.setAttribute("username", username);
                response.sendRedirect("tabla.jsp");
            } else {
                response.sendRedirect("error.jsp");
            }
        %> 
    </body> 
</html>
