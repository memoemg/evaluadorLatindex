<%-- 
    Document   : getion
    Created on : 15 abr. 2020, 06:44:10
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.criteriosPresentacion"%>
<%@page import="ucrindex.Revista"%>
<%@page import="java.io.*"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    criteriosPresentacion formularioPresentacion = new criteriosPresentacion();
    formularioPresentacion.setNavegacion(request.getParameter("checkCriterio8") != null);
    formularioPresentacion.setAccesoHistorico(request.getParameter("checkCriterio9") != null);
    formularioPresentacion.setMencionPeriodicidad(request.getParameter("URL10"));
    formularioPresentacion.setMembreteInicio(request.getParameter("checkCriterio11") != null);
    formularioPresentacion.setAfiliacionCuerposEditoriales(request.getParameter("URL12"));
    formularioPresentacion.setAfiliacionAutores(request.getParameter("checkCriterio13") != null);
    formularioPresentacion.setFechasRecepcionAceptacion(request.getParameter("checkCriterio14") != null);
    
    formularioPresentacion.setObservacion8(request.getParameter("observacion8"));
    formularioPresentacion.setObservacion9(request.getParameter("observacion9"));
    formularioPresentacion.setObservacion10(request.getParameter("observacion10"));
    formularioPresentacion.setObservacion11(request.getParameter("observacion11"));
    formularioPresentacion.setObservacion12(request.getParameter("observacion12"));
    formularioPresentacion.setObservacion13(request.getParameter("observacion13"));
    formularioPresentacion.setObservacion14(request.getParameter("observacion14"));
    
    misession.setAttribute("formularioPresentacion", formularioPresentacion);
    
%>

<%!
    public class debug {

        public debug()
        {

        }

        public void guardarArchivo(String nombre, String organismo, String url, String solicitante, String issn, String fechaHoy,
                boolean criterio8, boolean criterio9, String criterio10, boolean criterio11, String criterio12, boolean criterio13, boolean criterio14,
                String ocriterio8, String ocriterio9, String ocriterio10, String ocriterio11, String ocriterio12, String ocriterio13, String ocriterio14) {

            String datosUnidos = "Datos de la revista: \nRevista: " + nombre + "\nOrganismo: " + organismo + "\nISSN: " + issn + "\nURL: " + url + "\nSolicitante: " + solicitante + "\nFecha: " + fechaHoy;

            datosUnidos = datosUnidos + "\n\nPreevaluación Latindex: \n" + "Criterio 8 : " + criterio8 + "\nCriterio 9 : " + criterio9 + "\nCriterio 10 : " + criterio10
                    + "\nCriterio 11 : " + criterio11 + "\nCriterio 12 : " + criterio12 + "\nCriterio 13 : " + criterio13 + "\nCriterio 14 : " + criterio14;

            datosUnidos = datosUnidos + "\n\nObservaciones Latindex: \n" + "Observación 8 : " + ocriterio8 + "\nObservación 9 : " + ocriterio9 + "\nObservación 10 : " + ocriterio10
                    + "\nObservación 11 : " + ocriterio11 + "\nObservación 12 : " + ocriterio12 + "\nObservación 13 : " + ocriterio13 + "\nObservación 14 : " + ocriterio14;

            String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/" + nombre + "-presentacion-" + fechaHoy + ".txt";
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
                formularioPresentacion.getNavegacion(), formularioPresentacion.getAccesoHistorico(), formularioPresentacion.getMencionPeriodicidad(), formularioPresentacion.getMembreteInicio(), formularioPresentacion.getAfiliacionCuerposEditoriales(), formularioPresentacion.getAfiliacionAutores(), formularioPresentacion.getFechasRecepcionAceptacion(),
                formularioPresentacion.getObservacion8(), formularioPresentacion.getObservacion9(), formularioPresentacion.getObservacion10(), formularioPresentacion.getObservacion11(), formularioPresentacion.getObservacion12(), formularioPresentacion.getObservacion13(), formularioPresentacion.getObservacion14());
    %>  
    
    <div class="container">
        <h2 class="sinEspacios">Características de Gestión y Política Editorial</h2>
        <h3>Total de características: 8 </h3>
        <form name="gestion" action="contenido.jsp" method="POST">
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
                    <td><strong>15-Definición de la revista</strong><br><br>En la página de la revista 
                        deberá mencionarse el objetivo, cobertura temática y el público al que va dirigida. </td>
                    <td><input type="text" name="URL15" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                    <td><textarea name="observacion15" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>16-Autores externos</strong><br><br>Al menos el 50% de los trabajos publicados 
                        deben provenir de autores externos a la entidad editora y a sus cuerpos editoriales. 
                        En el caso de las revistas editadas por asociaciones, se considerarán autores 
                        pertenecientes a la entidad editora los que forman parte de la directiva de la asociación 
                        o que figuran en el equipo editorial de la revista. </td>
                    <td>
                      <label for="articulosAutoresInternos">Cantidad de documentos con autores internos:</label>
                      <input type="number" id="articulosAutoresInternos" name="articulosAutoresInternos" min="0" max="99" value="0">
                      <br><br>
                      <label for="articulosAutoresExternos">Cantidad de documentos con autores externos:</label>
                      <input type="number" id="articulosAutoresExternos" name="articulosAutoresExternos" min="0" max="99" value="0">
                    </td>
                    <td><textarea name="observacion16" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>17-Apertura editorial</strong><br><br>Al menos dos terceras partes de los 
                        miembros de los órganos editoriales colegiados (comités o consejos de la revista) 
                        deberán pertenecer a instituciones diferentes a la entidad editora.</td>
                    <td>
                      <label for="miembrosInternos">Cantidad de miembros internos:</label>
                      <input type="number" id="miembrosInternos" name="miembrosInternos" min="0" max="99" value="0">
                      <br><br>
                      <label for="miembrosExternos">Cantidad de miembros externos:</label>
                      <input type="number" id="miembrosExternos" name="miembrosExternos" min="0" max="99" value="0">
                    </td>
                    <td><textarea name="observacion17" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>18-Servicios de información</strong><br><br>La revista debe estar incluida 
                        en algún servicio de índices y resúmenes, directorios, catálogos, portales de 
                        revistas, hemerotecas virtuales, sistemas de categorización o listas del núcleo 
                        básico de revistas nacionales, entre otros servicios de información, que sean selectivos. </td>
                    <td><input type="text" name="URL18" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                    <td><textarea name="observacion18" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>19-Cumplimiento de la periodicidad</strong><br><br>La revista debe ser publicada 
                        al inicio del periodo declarado. Para las publicaciones con periodicidades trimestral, 
                        cuatrimestral y semestral deberán hacerlo dentro del primer mes. No cumplirá la 
                        característica cuando se haya publicado un solo número o fascículo para completar 
                        el volumen o año.</td>
                    <td><label for="fechaUltimoNumero">Fecha de publicación del último número:</label><br><br>
                      <input type="date" id="fechaUltimoNumero" name="fechaUltimoNumero">
                    </td>
                    <td><textarea name="observacion19" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>20-Políticas de acceso y reuso</strong><br><br>	La revista debe informar con 
                        claridad cuáles son las políticas de derechos de autor que establece respecto al 
                        acceso a sus archivos; cuáles derechos conservan y cuáles ceden a los autores y lectores.</td>
                    <td><input type="text" name="URL20" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                    <td><textarea name="observacion20" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>21-Adopción de códigos de ética</strong><br><br>La revista debe informar 
                        su adhesión a normas y códigos de ética internacionales. Pueden ser los 
                        establecidos por el Committee on Publication Ethics (Code of Conduct and Best 
                        Practices Guidelines for Journals Editors, COPE), por el International Committee of 
                        Medical Journal Editors (ICJME), algún otro o bien, tener su propio código de ética. </td>
                    <td><input type="text" name="URL21" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                    <td><textarea name="observacion21" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
                <tr>
                    <td><strong>22-Detección de plagio</strong><br><br>La revista debe manifestar cuáles 
                        son las políticas para la detección de plagio.</td>
                    <td><input type="text" name="URL22" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                    <td><textarea name="observacion22" rows="3" cols="30" maxlength="500"></textarea></td>
                </tr>
            </tbody>
            </table>
            <br>       
            <button type="button" name="back" onclick="history.back()">ATRÁS</button><div id="botonSiguiente"><input type="submit" value="SIGUIENTE" name="enviarGestion" onclick="javascript:return checkValidation()"/></div>      
        </form>
    </div>
    <footer>
        <p>Página 4 de 6</p>
    </footer>
    
    <script type="text/javascript">
        function checkValidation() {
            if (document.getElementById('articulosAutoresInternos').value === "") {
                alert("Por favor indique la cantidad de documentos con autores internos (mínimo 0)");
                return false;
            }
            if (document.getElementById('articulosAutoresExternos').value === "") {
                alert("Por favor indique la cantidad de documentos con autores externos (mínimo 0)");
                return false;
            }
            if (document.getElementById('miembrosInternos').value === "") {
                alert("Por favor indique la cantidad de miembros editoriales internos (mínimo 0)");
                return false;
            }            
            if (document.getElementById('miembrosExternos').value === "") {
                alert("Por favor indique la cantidad de miembros editoriales externos (mínimo 0)");
                return false;
            }
        }
    </script> 
    
</html>
