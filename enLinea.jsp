<%-- 
    Document   : enLinea
    Created on : 15 abr. 2020, 08:58:25
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.criteriosContenido"%>
<%@page import="ucrindex.Revista"%>
<%@page import="java.io.*"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    HttpSession misession= request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    criteriosContenido formularioContenido = new criteriosContenido();
    formularioContenido.setDocumentosOriginales(Integer.parseInt(request.getParameter("documentosOriginales")));
    formularioContenido.setOtroTipo(Integer.parseInt(request.getParameter("otrosDocumentos")));
    formularioContenido.setReferenciasBibliograficas(request.getParameter("URL24"));
    formularioContenido.setExigenciaOriginalidad(request.getParameter("URL25"));
    formularioContenido.setResumen(request.getParameter("checkCriterio26") != null);
    formularioContenido.setResumenDosIdiomas(request.getParameter("checkCriterio27") != null);
    formularioContenido.setPalabras(request.getParameter("checkCriterio28") != null);
    formularioContenido.setPalabrasDosIdiomas(request.getParameter("checkCriterio29")!= null);
    formularioContenido.setCantidadArticulosAnho(Integer.parseInt(request.getParameter("publicadosAnho")));
    
    formularioContenido.setObservacion23(request.getParameter("observacion23"));
    formularioContenido.setObservacion24(request.getParameter("observacion24"));
    formularioContenido.setObservacion25(request.getParameter("observacion25"));
    formularioContenido.setObservacion26(request.getParameter("observacion26"));
    formularioContenido.setObservacion27(request.getParameter("observacion27"));
    formularioContenido.setObservacion28(request.getParameter("observacion28"));
    formularioContenido.setObservacion29(request.getParameter("observacion29"));
    formularioContenido.setObservacion30(request.getParameter("observacion30"));
    
    misession.setAttribute("formularioContenido", formularioContenido);
    
    Revista revistaSolicitante = (Revista) misession.getAttribute("revistaSolicitante");
%>

<%!
    public class debug {

        public debug()
        {

        }

        public void guardarArchivo(String nombre, String organismo, String url, String solicitante, String issn, String fechaHoy,
                String criterio23, String criterio24, String criterio25, boolean criterio26, boolean criterio27, boolean criterio28, boolean criterio29, String criterio30,
                String ocriterio23, String ocriterio24, String ocriterio25, String ocriterio26, String ocriterio27, String ocriterio28, String ocriterio29, String ocriterio30) {

            String datosUnidos = "Datos de la revista: \nRevista: " + nombre + "\nOrganismo: " + organismo + "\nISSN: " + issn + "\nURL: " + url + "\nSolicitante: " + solicitante + "\nFecha: " + fechaHoy;

            datosUnidos = datosUnidos + "\n\nPreevaluación Latindex: \n" + "Criterio 23 : " + criterio23 + "\nCriterio 24 : " + criterio24 + "\nCriterio 25 : " + criterio25
                    + "\nCriterio 26 : " + criterio26 + "\nCriterio 27 : " + criterio27 + "\nCriterio 28 : " + criterio28 + "\nCriterio 29 : " + criterio29 + "\nCriterio 30 : " + criterio30;

            datosUnidos = datosUnidos + "\n\nObservaciones Latindex: \n" + "Observación 23 : " + ocriterio23 + "\nObservación 24 : " + ocriterio24 + "\nObservación 25 : " + ocriterio25
                    + "\nObservación 26 : " + ocriterio26 + "\nObservación 27 : " + ocriterio27 + "\nObservación 28 : " + ocriterio28 + "\nObservación 29 : " + ocriterio29 + "\nObservación 30 : " + ocriterio30;

            String nameOfTextFile = "/usr/share/apache-tomcat-8.5.39/webapps/UCRIndex/respaldo/" + nombre + "-contenido-" + fechaHoy + ".txt";
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
        String criterio23Construido = "Cantidad de documentos originales: " + formularioContenido.getDocumentosOriginales() + " Cantidad de otros tipos: " + formularioContenido.getOtroTipo();
        String criterio30Construido = "Cantidad de documentos publicado al año: " + formularioContenido.getCantidadArticulosAnho();
        respaldo.guardarArchivo(revistaSolicitante.getNombre(), revistaSolicitante.getOrganismo(), revistaSolicitante.getUrl(), revistaSolicitante.getSolicitante(), revistaSolicitante.getIssn(), revistaSolicitante.getFechaSolicitud(), 
                criterio23Construido, formularioContenido.getReferenciasBibliograficas(), formularioContenido.getExigenciaOriginalidad(), formularioContenido.getResumen(), formularioContenido.getResumenDosIdiomas(), formularioContenido.getPalabras(), formularioContenido.getPalabrasDosIdiomas(), criterio30Construido,
                formularioContenido.getObservacion23(), formularioContenido.getObservacion24(), formularioContenido.getObservacion25(), formularioContenido.getObservacion26(), formularioContenido.getObservacion27(), formularioContenido.getObservacion28(), formularioContenido.getObservacion29(), formularioContenido.getObservacion30());
    
    %> 
    <div class="container">
        <h2 class="sinEspacios">Características de Revistas en Línea</h2>
        <h3>Total de características: 8</h3>
        <%if(revistaSolicitante.getEsUCR()){%>
        <form name="enLinea" action="ucrindex.jsp" method="POST">
        <%}else{%>
        <form name="enLinea" action="envioLatindex.jsp" method="POST">
        <%}%>
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
                        <td><strong>31-Uso de protocolos de interoperabilidad</strong><br><br> La revista debe
                            incorporar protocolos de interoperabilidad que le permitan ser recolectada 
                            por otros sistemas de distribución. Debe indicar qué protocolo de interoperabilidad 
                            utiliza y la dirección electrónica para acceder. Asimismo, deberá incluir metaetiquetas 
                            tanto en la página de presentación como en los artículos. </td>
                        <td><input type="text" name="URL31" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion31" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>32-Uso de diferentes formatos de edición</strong><br><br> Para calificar, 
                            la revista debe usar más de un formato de edición para el despliegue y lectura de los 
                            textos completos. </td>
                        <td><input type="checkbox" id="checkCriterio32" name="checkCriterio32" value="ON" />
                        <label for="checkCriterio32">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion32" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>33-Servicios de valor agregado</strong><br><br>Para calificar, 
                            la revista debe incluir servicios agregados como RSS, multimedia (video, sonido); 
                            actualización constante (artículo por artículo); acceso a datos crudos 
                            (estadísticas y anexos); tener presencia en redes sociales de ámbito académico, 
                            facilidades para que personas con diferentes discapacidades puedan acceder al 
                            contenido de la revista, así como indicaciones sobre cómo citar los artículos, entre otros.</td>
                        <td><input type="text" name="URL33" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion33" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>34-Servicios de interactividad con el lector</strong><br><br>La revista debe 
                            incluir servicios que faciliten la interactividad con sus lectores, como servicios 
                            de alerta, espacios para comentarios, uso de foros para discusión del contenido, 
                            widgets y blogs, entre otros. </td>
                        <td><input type="text" name="URL34" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion34" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>35-Buscadores</strong><br><br>La revista debe contar con algún motor 
                            de búsqueda que permita realizar búsquedas por palabras o por índices, así como 
                            la posibilidad de utilizar operadores boléanos, entre otros. </td>
                        <td><input type="text" name="URL35" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion35" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>36-Uso de indentificadores de recurso uniforme</strong><br><br>Todos los 
                            enlaces que incluya la revista deben ser seguros, por lo que debe hacer uso del 
                            identificador de recursos uniforme (URI) por ejemplo, recursos como Handle o el 
                            Digital Object Identifier (DOI). </td>
                        <td><input type="checkbox" id="checkCriterio36" name="checkCriterio36" value="ON" />
                        <label for="checkCriterio36">Cumple el criterio</label><br></td>
                        <td><textarea name="observacion36" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>37-Uso de estadísticas</strong><br><br>La revista debe proporcionar 
                            herramientas relacionadas con el uso de estadísticas de su propia página. </td>
                        <td><input type="text" name="URL37" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion37" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>38-Políticas de preservación digital</strong><br><br>La revista debe 
                            informar sobre las políticas de preservación de archivos digitales que ha implementado. </td>
                        <td><input type="text" name="URL38" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacion38" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>       
            <button type="button" name="back" onclick="history.back()">ATRÁS</button><div id="botonSiguiente"><input type="submit" value="Enviar Formulario Latindex" name="enviarEnLinea"/></div>           
        </form>
    </div>
    <footer>
        <p>Página 6 de 6</p>
    </footer>
</html>
