<%-- 
    Document   : contenido
    Created on : 15 abr. 2020, 07:41:20
    Author     : guies
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"%>
<%@page import="ucrindex.criteriosGestion"%>
<%@page import="ucrindex.Revista"%>


<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    criteriosGestion formularioGestion = new criteriosGestion();
    formularioGestion.setDefinicionRevista(request.getParameter("URL15"));
    formularioGestion.setAutoresInternos(Integer.parseInt(request.getParameter("articulosAutoresInternos")));
    formularioGestion.setAutoresExternos(Integer.parseInt(request.getParameter("articulosAutoresExternos")));
    formularioGestion.setMiembrosExternos(Integer.parseInt(request.getParameter("miembrosExternos")));
    formularioGestion.setMiembrosInternos(Integer.parseInt(request.getParameter("miembrosInternos")));
    formularioGestion.setServiciosInformacion(request.getParameter("URL18"));
    formularioGestion.setCumplimientoPeriodicidad(request.getParameter("fechaUltimoNumero"));
    formularioGestion.setPoliticaAccesoReuso(request.getParameter("URL20"));
    formularioGestion.setCodigoEtica(request.getParameter("URL21"));
    formularioGestion.setDeteccionPlagio(request.getParameter("URL22"));
    
    formularioGestion.setObservacion15(request.getParameter("observacion15"));
    formularioGestion.setObservacion16(request.getParameter("observacion16"));
    formularioGestion.setObservacion17(request.getParameter("observacion17"));
    formularioGestion.setObservacion18(request.getParameter("observacion18"));
    formularioGestion.setObservacion19(request.getParameter("observacion19"));
    formularioGestion.setObservacion20(request.getParameter("observacion20"));
    formularioGestion.setObservacion21(request.getParameter("observacion21"));
    formularioGestion.setObservacion22(request.getParameter("observacion22"));
    
    misession.setAttribute("formularioGestion", formularioGestion);
    
%>

<%!
    public class debug {

        public debug()
        {

        }

        public void guardarArchivo(String nombre, String organismo, String url, String solicitante, String issn, String fechaHoy,
                String criterio15, String criterio16, String criterio17, String criterio18, String criterio19, String criterio20, String criterio21, String criterio22,
                String ocriterio15, String ocriterio16, String ocriterio17, String ocriterio18, String ocriterio19, String ocriterio20, String ocriterio21, String ocriterio22) {

            String datosUnidos = "Datos de la revista: \nRevista: " + nombre + "\nOrganismo: " + organismo + "\nISSN: " + issn + "\nURL: " + url + "\nSolicitante: " + solicitante + "\nFecha: " + fechaHoy;

            datosUnidos = datosUnidos + "\n\nPreevaluación Latindex: \n" + "Criterio 15 : " + criterio15 + "\nCriterio 16 : " + criterio16 + "\nCriterio 17 : " + criterio17
                    + "\nCriterio 18 : " + criterio18 + "\nCriterio 19 : " + criterio19 + "\nCriterio 20 : " + criterio20 + "\nCriterio 21 : " + criterio21 + "\nCriterio 22 : " + criterio22;

            datosUnidos = datosUnidos + "\n\nObservaciones Latindex: \n" + "Observación 15 : " + ocriterio15 + "\nObservación 16 : " + ocriterio16 + "\nObservación 17 : " + ocriterio17
                    + "\nObservación 18 : " + ocriterio18 + "\nObservación 19 : " + ocriterio19 + "\nObservación 20 : " + ocriterio20 + "\nObservación 21 : " + ocriterio21 + "\nObservación 22 : " + ocriterio22;

            String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/" + nombre + "-gestion-" + fechaHoy + ".txt";
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
        String criterio16Construido = "Articulos con autores internos: " + formularioGestion.getAutoresInternos() + " Artículos con autores externos: " + formularioGestion.getAutoresExternos();
        String criterio17Construido = "Miembros editoriales internos: " + formularioGestion.getMiembrosInternos() + " Miembros editoriales externos: " + formularioGestion.getMiembrosExternos();
        respaldo.guardarArchivo(revistaSolicitante.getNombre(), revistaSolicitante.getOrganismo(), revistaSolicitante.getUrl(), revistaSolicitante.getSolicitante(), revistaSolicitante.getIssn(), revistaSolicitante.getFechaSolicitud(), formularioGestion.getDefinicionRevista(), criterio16Construido, criterio17Construido, formularioGestion.getServiciosInformacion(), formularioGestion.getCumplimientoPeriodicidad(), formularioGestion.getPoliticaAccesoReuso(), formularioGestion.getCodigoEtica(), formularioGestion.getDeteccionPlagio(),
                formularioGestion.getObservacion15(), formularioGestion.getObservacion16(), formularioGestion.getObservacion17(), formularioGestion.getObservacion18(), formularioGestion.getObservacion19(), formularioGestion.getObservacion20(), formularioGestion.getObservacion21(), formularioGestion.getObservacion22());

    %> 
    <div class="container">
        <h2 class="sinEspacios">Características de Contenido</h2>
        <h3>Total de características: 8 </h3>
        <form name="contenido" action="enLinea.jsp" method="POST">
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
                        <td><strong>23-Contenido original</strong><br><br>Al menos el 40% de los artículos deben 
                            ser trabajos de investigación, comunicación científica o creación originales: 
                            artículos originales de investigación, artículos de revisión, artículos de opinión, 
                            ensayos y casos clínicos. </td>
                        <td>
                            <label for="documentosOriginales">Cantidad de documentos originales:</label>
                            <input type="number" id="documentosOriginales" name="documentosOriginales" min="0" max="99" value="0">
                            <br><br>
                            <label for="otrosDocumentos">Cantidad de otros tipos de documento:</label>
                            <input type="number" id="otrosDocumentos" name="otrosDocumentos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacion23" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>24-Elaboración de las referencias bibliográficas</strong><br><br> En las 
                            instrucciones a los autores deberán indicarse las normas de elaboración de las 
                            referencias bibliográficas adoptando una norma internacional ampliamente aceptada 
                            (APA, Harvard, ISO, Vancouver o alguna otra). </td>
                        <td><input type="text" name="URL24" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion24" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>25-Exigencia de originalidad</strong><br><br>En la presentación de la revista o en
                            las instrucciones a los autores debe ser explícita la exigencia de originalidad para 
                            los trabajos sometidos a publicación. </td>
                        <td><input type="text" name="URL25" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion25" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>26-Resumen</strong><br><br>Todos los artículos originales, de revisión y 
                            ensayos deberán ser acompañados de un resumen en el idioma original del trabajo</td>
                        <td><input type="checkbox" id="checkCriterio26" name="checkCriterio26" value="ON" />
                            <label for="checkCriterio26">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion26" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>27-Resumen en dos idiomas</strong><br><br>Todos los artículos originales, 
                            de revisión y ensayos deben incluir resúmenes en el idioma original del trabajo y 
                            en un segundo idioma. </td>
                        <td><input type="checkbox" id="checkCriterio27" name="checkCriterio27" value="ON" />
                            <label for="checkCriterio27">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion27" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>28-Palabras clave</strong><br><br>Todos los artículos originales, de revisión 
                            y ensayos deben incluir palabras clave o equivalente en el idioma original del trabajo. </td>
                        <td><input type="checkbox" id="checkCriterio28" name="checkCriterio28" value="ON" />
                            <label for="checkCriterio28">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion28" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>29-Palabras clave en dos idiomas</strong><br><br>Todos los artículos originales, 
                            de revisión y ensayos deben incluir palabras clave o equivalentes en el idioma 
                            original del trabajo y en un segundo idioma</td>
                        <td><input type="checkbox" id="checkCriterio29" name="checkCriterio29" value="ON" />
                            <label for="checkCriterio29">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion29" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>30-Cantidad de artículos publicados por año</strong><br><br>La revista debe 
                            publicar al menos cinco artículos originales, de revisión o ensayos por año. </td>
                        <td>
                            <label for="publicadosAnho">Cantidad de artículos:</label>
                            <input type="number" id="publicadosAnho" name="publicadosAnho" min="0" max="199" value="0">
                        </td>
                        <td><textarea name="observacion30" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>       
            <button type="button" name="back" onclick="history.back()">ATRÁS</button><div id="botonSiguiente"><input type="submit" value="SIGUIENTE" name="enviarContenido" onclick="javascript:return checkValidation()"/></div>      
        </form>
    </div>
    <footer>
        <p>Página 5 de 6</p>
    </footer>
    
    <script type="text/javascript">
        function checkValidation() {
            if (document.getElementById('documentosOriginales').value === "") {
                alert("Por favor indique la cantidad de documentos originales (mínimo 0)");
                return false;
            }
            if (document.getElementById('otrosDocumentos').value === "") {
                alert("Por favor indique la cantidad de otros documentos (mínimo 0)");
                return false;
            }
            if (document.getElementById('publicadosAnho').value === "") {
                alert("Por favor indique la cantidad de artículos publicados al año (mínimo 0)");
                return false;
            }            
        }
    </script> 
    
</html>
