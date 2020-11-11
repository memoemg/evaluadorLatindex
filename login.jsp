<%-- 
    Document   : login
    Created on : 27/04/2020, 09:25:50 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <body> 
    <center> 
        <h2>Introduzca sus credenciales</h2> 
        <form action="loginCheck.jsp" method="post">
            Usuario: <input type="text" name="username"><br><br>
            Contraseña: <input type="password" name="password"><br><br>
            <button type="button" name="back" onclick="history.back()">Volver</button><input type="submit" value="Ingresar">
        </form> 
    </center>
</body>
</html>
