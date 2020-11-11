<%-- 
    Document   : calculoNotaLatindex
    Created on : 30/04/2020, 09:20:37 AM
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"  %>
<%@page import="java.sql.*"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="java.util.Properties"%>
<%@page import="ucrindex.Revista"%>
<%@page import="ucrindex.basicosEvaluados"%>
<%@page import="ucrindex.gestionEvaluados"%>
<%@page import="ucrindex.enLineaEvaluados"%>
<%@page import="ucrindex.contenidoEvaluados"%>
<%@page import="ucrindex.presentacionEvaluados"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    enLineaEvaluados enLineaRecuperados = (enLineaEvaluados) misession.getAttribute("enLineaRecuperados");

    if (request.getParameter("checkCriterio31") != null) {
        enLineaRecuperados.setInteroperabilidad("Sí cumple");
    } else {
        enLineaRecuperados.setInteroperabilidad("No cumple");
    }

    enLineaRecuperados.setFormatosEdicion(request.getParameter("checkCriterio32") != null);

    if (request.getParameter("checkCriterio33") != null) {
        enLineaRecuperados.setValorAgregado("Sí cumple");
    } else {
        enLineaRecuperados.setValorAgregado("No cumple");
    }

    if (request.getParameter("checkCriterio34") != null) {
        enLineaRecuperados.setInteractividad("Sí cumple");
    } else {
        enLineaRecuperados.setInteractividad("No cumple");
    }

    if (request.getParameter("checkCriterio35") != null) {
        enLineaRecuperados.setBuscadores("Sí cumple");
    } else {
        enLineaRecuperados.setBuscadores("No cumple");
    }

    enLineaRecuperados.setIdentificadoresDeRecurso(request.getParameter("checkCriterio36") != null);

    if (request.getParameter("checkCriterio37") != null) {
        enLineaRecuperados.setEstadisticas("Sí cumple");
    } else {
        enLineaRecuperados.setEstadisticas("No cumple");
    }

    if (request.getParameter("checkCriterio38") != null) {
        enLineaRecuperados.setPoliticaPreservacion("Sí cumple");
    } else {
        enLineaRecuperados.setPoliticaPreservacion("No cumple");
    }

    enLineaRecuperados.setObservacion31(request.getParameter("observacionEva31"));
    enLineaRecuperados.setObservacion32(request.getParameter("observacionEva32"));
    enLineaRecuperados.setObservacion33(request.getParameter("observacionEva33"));
    enLineaRecuperados.setObservacion34(request.getParameter("observacionEva34"));
    enLineaRecuperados.setObservacion35(request.getParameter("observacionEva35"));
    enLineaRecuperados.setObservacion36(request.getParameter("observacionEva36"));
    enLineaRecuperados.setObservacion37(request.getParameter("observacionEva37"));
    enLineaRecuperados.setObservacion38(request.getParameter("observacionEva38"));

    misession.setAttribute("enLineaRecuperados", enLineaRecuperados);

%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Evaluación Latindex y UCRÍndex 2020</title>
    </head>
    <body>
        <h1>Resultado Latindex</h1>

        <%            
            int criteriosCumplidos = 0;
            String cumpleCriteriosBasicos = "NO";
            String indexada = "NO";
            double notaLatindex = 0.0000;

            basicosEvaluados basicosRecuperados = (basicosEvaluados) misession.getAttribute("basicosRecuperados");
            basicosRecuperados.calcularCriteriosCumplidos();
            criteriosCumplidos += basicosRecuperados.getCriteriosCumplidos();

            if (basicosRecuperados.getCriteriosCumplidos() == 7) {
                cumpleCriteriosBasicos = "SÍ";
            }

            presentacionEvaluados presentacionRecuperados = (presentacionEvaluados) misession.getAttribute("presentacionRecuperados");
            presentacionRecuperados.calcularCriteriosCumplidos();
            criteriosCumplidos += presentacionRecuperados.getCriteriosCumplidos();

            gestionEvaluados gestionRecuperados = (gestionEvaluados) misession.getAttribute("gestionRecuperados");
            gestionRecuperados.calcularCriteriosCumplidos();
            criteriosCumplidos += gestionRecuperados.getCriteriosCumplidos();

            contenidoEvaluados contenidoRecuperados = (contenidoEvaluados) misession.getAttribute("contenidoRecuperados");
            contenidoRecuperados.calcularCriteriosCumplidos();
            criteriosCumplidos += contenidoRecuperados.getCriteriosCumplidos();

            enLineaRecuperados.calcularCriteriosCumplidos();
            criteriosCumplidos += enLineaRecuperados.getCriteriosCumplidos();

            if ((criteriosCumplidos > 30)&&(cumpleCriteriosBasicos.equals("SÍ"))) {
                indexada = "SÍ";
            }

            notaLatindex = (criteriosCumplidos * 100.0000) / 38.0000;

        %>
        <form name="notaLatindex" action="guardarLatindex.jsp" method="POST">
            <h4>Criterios cumplidos: <%=criteriosCumplidos%></h4>
            <h4>Criterios fallados: <%=38 - criteriosCumplidos%></h4>
            <h4>Porcentaje de autores externos (se requiere 50%): <%=gestionRecuperados.getPorcentajeAutoresExternos()%>%</h4>
            <h4>Porcentaje de apertura editorial (se requiere 66.6%): <%=gestionRecuperados.getPorcentajeAperturaEditorial()%>%</h4>
            <h4>Porcentaje de contenido original (se requiere 40%): <%=contenidoRecuperados.getPorcentajeContenidoOriginal()%>%</h4>
            <h4>Cumple con todos los criterios básicos: <%=cumpleCriteriosBasicos%></h4>
            <h4>Revista indexada: <%=indexada%></h4>
            <h4>Nota: <%=notaLatindex%></h4>

            
        <%    
            basicosRecuperados.setCriteriosCumplidos(0);
            presentacionRecuperados.setCriteriosCumplidos(0);
            contenidoRecuperados.setCriteriosCumplidos(0);
            gestionRecuperados.setCriteriosCumplidos(0);
            enLineaRecuperados.setCriteriosCumplidos(0);
        %>    
            
            <input type="hidden" id="notaLatindex" name="notaLatindex" value="<%=notaLatindex%>" />
            <input type="hidden" id="indexada" name="indexada" value="<%=indexada%>" />
            <input type="submit" value="Volver" onclick="window.history.back()" />
            <input type="submit" value="Guardar evaluación Latindex" name="guardarLatindex" />
        </form>

    </body>
</html>
