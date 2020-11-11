<%-- 
    Document   : datosRevista
    Created on : 14 abr. 2020, 19:04:29
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<link rel="stylesheet" type="text/css" href=" css/main.css" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Solicitud de Evaluación Latindex y UCRÍndex</title>
        <link rel="stylesheet" type="text/css" href=" css/main.css" />
        <link rel="canonical" href="https://ucrindex.ucr.ac.cr/"/>
        <meta name="description" content="Formulario para la evaluación de revistas científicas en Latindex y UCR Index, Costa Rica."/>
        <meta name="keywords" content="latindex, ucrindex, revistas, universidad de costa rica, evaluacion, criterio, calidad, editorial, ucr index, ucr,costa rica"/>
        <meta property="og:title" content="Evaluaciones Latindex / UCR Index"/>
        <meta property="og:type" content="website"/>
        <meta property="og:url" content="https://ucrindex.ucr.ac.cr/images/.thumbs/image/solicitud_evaluaciones.png"/>
        <meta property="og:site_name" content="UCRIndex"/>
        <meta property="fb:admins" content="136503766382763"/>
        <meta property="og:description" content="Formulario para la evaluación de revistas científicas en Latindex y UCR Index, Costa Rica."/>
        <meta name="twitter:card" content="summary" />
        <meta name="twitter:site" content="@ciencia_ucr" />
        <meta name="twitter:creator" content="@cienciaucr" />
        <meta name="twitter:domain" content="Ciencia_UCR" />
        <meta name="twitter:title" content="Formulario para evaluación de revistas UCR Index y Latindex" />
        <meta name="twitter:description" content="Formulario para la evaluación de revistas científicas en Latindex y UCR Index, Costa Rica." />
        <meta name="twitter:image" content="https://ucrindex.ucr.ac.cr/images/.thumbs/image/solicitud_evaluaciones.png" />
    </head>
    <div id="myModal" class="modal">
        <div class="modal-content">
            <div class="modal-body">
                <span class="close">&times;</span>
                <p>Este formulario es la forma oficial de solicitar evaluación a Latindex Costa Rica.</p>
                <p>Si tiene dudas con el formulario puede llamar de Lunes a Viernes de 8:00 a.m. a 4:00 p.m. al 2511-1361 o comunicarse al correo jorge.polanco@ucr.ac.cr.</p>
                <p>Información adicional: <a href="https://ucrindex.ucr.ac.cr/?page_id=68">Manual de evaluación Latindex</a></p>
            </div>
        </div>
    </div>
    <header>
        <h1>Solicitud de evaluación para Latindex y UCRÍndex</h1>
    </header>
    <div class="container">
        <h1 class="sinEspacios">Datos de la Revista</h1>
        <hr>
        <form name="datosRevista" action="basicas.jsp" method="POST">
            <table border="0">
                <thead>
                </thead>
                <tbody>
                    <tr>
                        <td>Nombre de la revista:</td>
                        <td><input type="text" name="nombreRevista" id="nombreRevista" value="" size="80"/></td>
                    </tr>
                    <tr>
                        <td>Organismo responsable:</td>
                        <td><input type="text" name="organismoResponsable" id="organismoResponsable" value="" size="80"/></td>
                    </tr>
                    <tr>
                        <td>Correo electrónico de la revista:</td>
                        <td><input type="email" name="correoRevista" id="correoRevista" value="" size="80" title="Solo se admiten direcciones de correo electrónico válidas"/></td>
                    </tr>
                    <tr>
                        <td>ISSN Electrónico:</td>
                        <td><input type="text" name="issn" id="issn" value="" /></td>
                    </tr>
                    <tr>
                        <td>URL:</td>
                        <td><input type="text" name="url" id="url" value="" size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?" title="Solo se admiten URLs válidas"/></td>
                    </tr>
                    <tr>
                        <td>Nombre del responsable de la revista (Editor/Director):</td>
                        <td><input type="text" name="nombreResponsable" id="nombreResponsable" value="" size="80"/></td>
                    </tr>
                    <tr>
                        <td>Nombre de quien llena la solicitud de evaluación:</td>
                        <td><input type="text" name="nombreSolicitante" id="nombreSolicitante" value="" size="80"/></td>
                    </tr>
                    <tr>
                        <td>Fecha de la solicitud:</td>
                        <%
                            String fechaHoy = new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date());
                        %>
                        <td><input type="text" name="fechaSolicitud" value="<%= fechaHoy%>" readonly="readonly" disabled="disabled"/></td>
                    </tr>
                </tbody>
            </table>

            <br>
            <div><a>¿Es una Revista UCR?</a><input type="checkbox" name="checkUCR" id="checkUCR"></div>
            <br>         
            <div id="botonSiguiente"><input type="submit" value="SIGUIENTE" name="enviarDatos" onclick="javascript:return checkValidation()" /></div>      
        </form>
    </div>
    <footer class="index">
        <p>Página 1 de 6</p>
    </footer>

    <script type="text/javascript">
        function checkValidation() {
            if (document.getElementById('nombreRevista').value === "") {
                alert("Por favor indique el nombre de la revista");
                return false;
            }
            if (document.getElementById('organismoResponsable').value === "") {
                alert("Por favor indique el organismo responsable de la revista");
                return false;
            }
            if (document.getElementById('correoRevista').value === "") {
                alert("Por favor indique el correo de la revista");
                return false;
            }            
            if (document.getElementById('issn').value === "") {
                alert("Por favor indique el ISSN de la revista");
                return false;
            }
            if (document.getElementById('url').value === "") {
                alert("Por favor indique el url de la revista");
                return false;
            }
            if (document.getElementById('nombreResponsable').value === "") {
                alert("Por favor indique el nombre del responsable de la revista");
                return false;
            }
            if (document.getElementById('nombreSolicitante').value === "") {
                alert("Por favor indique el nombre de quien solicita la evaluación");
                return false;
            }
        }
    </script> 

</html>
