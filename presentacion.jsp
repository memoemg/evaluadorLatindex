<%-- 
    Document   : presentacion
    Created on : 14 abr. 2020, 20:24:00
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.criteriosBasicos"%>
<%@page import="ucrindex.Revista"%>
<%@page import="java.io.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    criteriosBasicos formularioBasicos = new criteriosBasicos();
    formularioBasicos.setResponsables(request.getParameter("URL1"));
    formularioBasicos.setGeneracionContinua(request.getParameter("URL2"));
    formularioBasicos.setIdAutores(request.getParameter("URL3"));
    formularioBasicos.setEntidadEditora(request.getParameter("URL4"));
    formularioBasicos.setInstruccionesAutores(request.getParameter("URL5"));
    formularioBasicos.setSistemaArbitraje(request.getParameter("URL6"));
    formularioBasicos.setIssnCriterio(request.getParameter("URL7"));

    formularioBasicos.setObservacion1(request.getParameter("observacion1"));
    formularioBasicos.setObservacion2(request.getParameter("observacion2"));
    formularioBasicos.setObservacion3(request.getParameter("observacion3"));
    formularioBasicos.setObservacion4(request.getParameter("observacion4"));
    formularioBasicos.setObservacion5(request.getParameter("observacion5"));
    formularioBasicos.setObservacion6(request.getParameter("observacion6"));
    formularioBasicos.setObservacion7(request.getParameter("observacion7"));

    misession.setAttribute("formularioBasicos", formularioBasicos);

%>

<%!
    public class debug {

        public debug()
        {

        }

        public void guardarArchivo(String nombre, String organismo, String url, String solicitante, String issn, String fechaHoy,
                String criterio1, String criterio2, String criterio3, String criterio4, String criterio5, String criterio6, String criterio7,
                String ocriterio1, String ocriterio2, String ocriterio3, String ocriterio4, String ocriterio5, String ocriterio6, String ocriterio7) {

            String datosUnidos = "Datos de la revista: \nRevista: " + nombre + "\nOrganismo: " + organismo + "\nISSN: " + issn + "\nURL: " + url + "\nSolicitante: " + solicitante + "\nFecha: " + fechaHoy;

            datosUnidos = datosUnidos + "\n\nPreevaluación Latindex: \n" + "Criterio 1 : " + criterio1 + "\nCriterio 2 : " + criterio2 + "\nCriterio 3 : " + criterio3
                    + "\nCriterio 4 : " + criterio4 + "\nCriterio 5 : " + criterio5 + "\nCriterio 6 : " + criterio6 + "\nCriterio 7 : " + criterio7;

            datosUnidos = datosUnidos + "\n\nObservaciones Latindex: \n" + "Observación 1 : " + ocriterio1 + "\nObservación 2 : " + ocriterio2 + "\nObservación 3 : " + ocriterio3
                    + "\nObservación 4 : " + ocriterio4 + "\nObservación 5 : " + ocriterio5 + "\nObservación 6 : " + ocriterio6 + "\nObservación 7 : " + ocriterio7;

            String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/" + nombre + "-basicos-" + fechaHoy + ".txt";
            try {
                PrintWriter pw = new PrintWriter(new FileOutputStream(nameOfTextFile));
                pw.println(datosUnidos);
                //clean up
                pw.close();
            } catch (IOException e) {
                System.err.println(e.getMessage());
            }

        }
    }

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
    <%        
        debug respaldo = new debug();
        Revista revistaSolicitante = (Revista) misession.getAttribute("revistaSolicitante");
        respaldo.guardarArchivo(revistaSolicitante.getNombre(), revistaSolicitante.getOrganismo(), revistaSolicitante.getUrl(), revistaSolicitante.getSolicitante(), revistaSolicitante.getIssn(), revistaSolicitante.getFechaSolicitud(), 
                formularioBasicos.getResponsables(), formularioBasicos.getGeneracionContinua(), formularioBasicos.getIdAutores(), formularioBasicos.getEntidadEditora(), formularioBasicos.getInstruccionesAutores(), formularioBasicos.getSistemaArbitraje(), formularioBasicos.getIssnCriterio(), 
                formularioBasicos.getObservacion1(), formularioBasicos.getObservacion2(), formularioBasicos.getObservacion3(), formularioBasicos.getObservacion4(), formularioBasicos.getObservacion5(), formularioBasicos.getObservacion6(), formularioBasicos.getObservacion7());
    %>    
    <div class="container">
        <h2 class="sinEspacios">Características de Presentación</h2>
        <h3>Total de características: 7 </h3>
        <form name="presentacion" action="gestion.jsp" method="POST">
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
                        <td><strong>8-Navegación y funcionalidad en el acceso a contenidos</strong><br><br>Debe contar 
                            con sumarios, tablas de contenido o una estructura que permita el acceso a los artículos 
                            en un máximo de tres clics. </td>
                        <td><input type="checkbox" id="checkCriterio8" name="checkCriterio8" value="ON" />
                            <label for="checkCriterio8">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion8" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>9-Acceso histórico al contenido</strong><br><br>La revista debe facilitar 
                            acceso a todos sus contenidos o al menos a los publicados durante los últimos cinco años. </td>
                        <td><input type="checkbox" id="checkCriterio9" name="checkCriterio9" value="ON" />
                            <label for="checkCriterio9">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion9" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>10-Mención de periodicidad</strong><br><br> La revista debe mencionar su periodicidad, 
                            el número de fascículos que editará al año o en su caso, la declaración de periodicidad 
                            continuada. Debe incluir las fechas que cubre.</td>
                        <td><input type="text" name="URL10" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion10" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>11-Membrete bibliográfico al inicio del artículo</strong><br><br>
                            La revista debe incluir el membrete bibliográfico al inicio de cada artículo. 
                            El membrete debe contener al menos: título completo o abreviado, fecha que cubre y 
                            la numeración de la revista (volumen, número, parte o sus equivalentes). </td>
                        <td><input type="checkbox" id="checkCriterio11" name="checkCriterio11" value="ON" />
                            <label for="checkCriterio11">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion11" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>12-Afiliación institucional de los miembros de los cuerpos editoriales</strong><br><br>
                            La revista debe proporcionar los nombres completos de las instituciones a las que están 
                            adscritos los miembros de los diferentes cuerpos editoriales o en su caso declaración 
                            de trabajador independiente. No basta que se indique solamente el país. </td>
                        <td><input type="text" name="URL12" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion12" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>13-Afiliación de los autores</strong><br><br>En cada documento deberá constar 
                            el nombre completo de la institución de trabajo del autor o autores, o en su caso, 
                            declaración de trabajador independiente. </td>
                        <td><input type="checkbox" id="checkCriterio13" name="checkCriterio13" value="ON" />
                            <label for="checkCriterio13">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion13" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>14-Fechas de recepción y aceptación de originales</strong><br><br>
                            En los artículos (originales, de revisión y ensayos) deben constar las fechas 
                            de recepción y aceptación de originales. Califica solamente si indican ambas fechas.</td>
                        <td><input type="checkbox" id="checkCriterio14" name="checkCriterio14" value="ON" />
                            <label for="checkCriterio14">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion14" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>       
            <button type="button" name="back" onclick="history.back()">ATRÁS</button><div id="botonSiguiente"><input type="submit" value="SIGUIENTE" name="enviarPresentacion"/></div>      
        </form>
    </div>
    <footer>
        <p>Página 3 de 6</p>
    </footer>
</html>
