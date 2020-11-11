<%-- 
    Document   : calculoNotaLatindexConfirma
    Created on : 10/08/2020, 12:55:22 PM
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
<%@page import="ucrindex.revistaConfirmada"%>
<%@page import="ucrindex.basicosConfirmados"%>
<%@page import="ucrindex.gestionConfirmados"%>
<%@page import="ucrindex.enLineaConfirmados"%>
<%@page import="ucrindex.contenidoConfirmados"%>
<%@page import="ucrindex.presentacionConfirmados"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    enLineaConfirmados enLineaRecuperados = (enLineaConfirmados) misession.getAttribute("enLineaRecuperados");

    if (request.getParameter("checkConfirmaCriterio31") != null) {
        enLineaRecuperados.setInteroperabilidadEva("Sí cumple");
    } else {
        enLineaRecuperados.setInteroperabilidadEva("No cumple");
    }
    
    if (request.getParameter("checkConfirmaCriterio32") != null) {
        enLineaRecuperados.setFormatosEdicionEva("Sí cumple");
    } else {
        enLineaRecuperados.setFormatosEdicionEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio33") != null) {
        enLineaRecuperados.setValorAgregadoEva("Sí cumple");
    } else {
        enLineaRecuperados.setValorAgregadoEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio34") != null) {
        enLineaRecuperados.setInteractividadEva("Sí cumple");
    } else {
        enLineaRecuperados.setInteractividadEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio35") != null) {
        enLineaRecuperados.setBuscadoresEva("Sí cumple");
    } else {
        enLineaRecuperados.setBuscadoresEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio36") != null) {
        enLineaRecuperados.setIdentificadoresDeRecursoEva("Sí cumple");
    } else {
        enLineaRecuperados.setIdentificadoresDeRecursoEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio37") != null) {
        enLineaRecuperados.setEstadisticasEva("Sí cumple");
    } else {
        enLineaRecuperados.setEstadisticasEva("No cumple");
    }

    if (request.getParameter("checkConfirmaCriterio38") != null) {
        enLineaRecuperados.setPoliticaPreservacionEva("Sí cumple");
    } else {
        enLineaRecuperados.setPoliticaPreservacionEva("No cumple");
    }

    enLineaRecuperados.setObservacion31eva(request.getParameter("observacionEva31"));
    enLineaRecuperados.setObservacion32eva(request.getParameter("observacionEva32"));
    enLineaRecuperados.setObservacion33eva(request.getParameter("observacionEva33"));
    enLineaRecuperados.setObservacion34eva(request.getParameter("observacionEva34"));
    enLineaRecuperados.setObservacion35eva(request.getParameter("observacionEva35"));
    enLineaRecuperados.setObservacion36eva(request.getParameter("observacionEva36"));
    enLineaRecuperados.setObservacion37eva(request.getParameter("observacionEva37"));
    enLineaRecuperados.setObservacion38eva(request.getParameter("observacionEva38"));
    
    enLineaRecuperados.setObservacion31confirma(request.getParameter("observacionConfirma31"));
    enLineaRecuperados.setObservacion32confirma(request.getParameter("observacionConfirma32"));
    enLineaRecuperados.setObservacion33confirma(request.getParameter("observacionConfirma33"));
    enLineaRecuperados.setObservacion34confirma(request.getParameter("observacionConfirma34"));
    enLineaRecuperados.setObservacion35confirma(request.getParameter("observacionConfirma35"));
    enLineaRecuperados.setObservacion36confirma(request.getParameter("observacionConfirma36"));
    enLineaRecuperados.setObservacion37confirma(request.getParameter("observacionConfirma37"));
    enLineaRecuperados.setObservacion38confirma(request.getParameter("observacionConfirma38"));

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

            basicosConfirmados basicosRecuperados = (basicosConfirmados) misession.getAttribute("basicosRecuperados");
            basicosRecuperados.calcularCriteriosCumplidosEva();
            criteriosCumplidos += basicosRecuperados.getCriteriosCumplidosEva();

            if (basicosRecuperados.getCriteriosCumplidosEva() == 7) {
                cumpleCriteriosBasicos = "SÍ";
            }

            presentacionConfirmados presentacionRecuperados = (presentacionConfirmados) misession.getAttribute("presentacionRecuperados");
            presentacionRecuperados.calcularCriteriosCumplidosEva();
            criteriosCumplidos += presentacionRecuperados.getCriteriosCumplidosEva();

            gestionConfirmados gestionRecuperados = (gestionConfirmados) misession.getAttribute("gestionRecuperados");
            gestionRecuperados.calcularCriteriosCumplidosEva();
            criteriosCumplidos += gestionRecuperados.getCriteriosCumplidosEva();

            contenidoConfirmados contenidoRecuperados = (contenidoConfirmados) misession.getAttribute("contenidoRecuperados");
            contenidoRecuperados.calcularCriteriosCumplidosEva();
            criteriosCumplidos += contenidoRecuperados.getCriteriosCumplidosEva();

            enLineaRecuperados.calcularCriteriosCumplidosEva();
            criteriosCumplidos += enLineaRecuperados.getCriteriosCumplidosEva();

            if ((criteriosCumplidos > 30)&&(cumpleCriteriosBasicos.equals("SÍ"))) {
                indexada = "SÍ";
            }

            notaLatindex = (criteriosCumplidos * 100.0000) / 38.0000;

        %>
        <form name="notaLatindex" action="guardarLatindexConfirmada.jsp" method="POST">
            <h4>Criterios cumplidos: <%=criteriosCumplidos%></h4>
            <h4>Criterios fallados: <%=38 - criteriosCumplidos%></h4>
            <h4>Porcentaje de autores externos (se requiere 50%): <%=gestionRecuperados.getPorcentajeAutoresExternosEva()%>%</h4>
            <h4>Porcentaje de apertura editorial (se requiere 66.6%): <%=gestionRecuperados.getPorcentajeAperturaEditorialEva()%>%</h4>
            <h4>Porcentaje de contenido original (se requiere 40%): <%=contenidoRecuperados.getPorcentajeContenidoOriginalEva()%>%</h4>
            <h4>Cumple con todos los criterios básicos: <%=cumpleCriteriosBasicos%></h4>
            <h4>Revista indexada: <%=indexada%></h4>
            <h4>Nota: <%=notaLatindex%></h4>
            <br>
            <h4>Próxima evaluación Latindex:</h4>
            <input type="text" name="proximaEva" placeholder='Fecha de la próxima evaluación' size="80">
            <br><br>
            
        <%    
            basicosRecuperados.setCriteriosCumplidosEva(0);
            presentacionRecuperados.setCriteriosCumplidosEva(0);
            contenidoRecuperados.setCriteriosCumplidosEva(0);
            gestionRecuperados.setCriteriosCumplidosEva(0);
            enLineaRecuperados.setCriteriosCumplidosEva(0);
        %>    
            
            <input type="hidden" id="notaLatindex" name="notaLatindex" value="<%=notaLatindex%>" />
            <input type="hidden" id="indexada" name="indexada" value="<%=indexada%>" />
            <input type="submit" value="Volver" onclick="window.history.back()" />
            <input type="submit" value="Guardar confirmación Latindex" name="guardarLatindex" />
        </form>

    </body>
</html>
