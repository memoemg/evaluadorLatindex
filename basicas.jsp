<%-- 
    Document   : basicas
    Created on : 14 abr. 2020, 19:22:32
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.Revista"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession = request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    Revista laRevista= new Revista();
    laRevista.setNombre(request.getParameter("nombreRevista"));
    laRevista.setOrganismo(request.getParameter("organismoResponsable"));
    laRevista.setIssn(request.getParameter("issn"));
    laRevista.setUrl(request.getParameter("url"));
    laRevista.setResponsable(request.getParameter("nombreResponsable"));
    laRevista.setSolicitante(request.getParameter("nombreSolicitante"));
    laRevista.setCorreo(request.getParameter("correoRevista"));
    laRevista.setFechaSolicitud(new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date()));
    laRevista.setEsUCR(request.getParameter("checkUCR") != null);
    misession.setAttribute("revistaSolicitante", laRevista);
    
%>

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
    <header>
        <h1>Solicitud de evaluación para Latindex y UCRÍndex</h1>
    </header>
    <div class="container">
        <h2 class="sinEspacios">Características Básicas</h2>
        <h3>Total de características: 7 (todas obligatorias)</h3>
        <form name="basicas" action="presentacion.jsp" method="POST">
            <table border="1">
                <thead>
                    <tr>
                        <th>Criterio</th>
                        <th>Evidencia</th>
                        <th>Comentario</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>1-Responsables editoriales</strong><br><br>La revista deberá contar con un editor o responsable científico 
                            y cuerpos editoriales (comité editorial, consejo editorial, consejo de redacción u otras 
                            denominaciones); los miembros de los cuerpos editoriales deberán aparecer listados por su nombre.
                            Para calificar será indispensable que se cumpla con todos estos requerimientos y que la 
                            información sea visible en el sitio web.</td>
                        <td><input type="text" name="URL1" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion1" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>2-Generación continua de contenidos</strong><br><br> La revista debe demostrar la generación 
                            ininterrumpida de nuevos contenidos durante los últimos dos años consecutivos, conforme la periodicidad 
                            declarada.</td>
                        <td><input type="text" name="URL2" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion2" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>3-Identificación de los autores</strong><br><br>	Todos los documentos publicados en la revista
                            deben estar firmados por los autores o tener declaración de autor institucional o indicar su origen. </td>
                        <td><input type="text" name="URL3" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion3" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>4-Entidad editora de la revista</strong><br><br>Deberá aportarse en lugar visible el nombre de 
                            la entidad o institución editora de la revista la cual deberá ser de toda solvencia académica, así 
                            como su dirección postal completa y de correo electrónico. </td>
                        <td><input type="text" name="URL4" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion4" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>5-Instrucciones a los autores</strong><br><br>Las instrucciones a los autores deben aparecer 
                            siempre en el sitio web de la revista.</td>
                        <td><input type="text" name="URL5" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion5" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>6-Sistema de arbitraje</strong><br><br>En la revista debe detallarse el procedimiento 
                            empleado para la selección de los artículos a publicar. El arbitraje deberá ser 
                            externo a la revista e indicar el tipo de revisión, incluyendo la instancia responsable de la
                            decisión final. </td>
                        <td><input type="text" name="URL6" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion6" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>7-ISSN</strong><br><br>Las revistas en línea deben contar con su propio ISSN. 
                            No se da por cumplido si aparece únicamente el ISSN de la versión impresa. </td>
                        <td><input type="text" name="URL7" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion7" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>         
            <button type="button" name="back" onclick="history.back()">ATRÁS</button><div id="botonSiguiente"><input type="submit" value="SIGUIENTE" name="enviarBasicas"/></div>      
        </form>
    </div>
    <footer>
        <p>Página 2 de 6</p>
    </footer>
</html>