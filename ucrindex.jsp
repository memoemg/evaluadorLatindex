<%-- 
    Document   : ucrindex
    Created on : 15 abr. 2020, 09:25:14
    Author     : guies
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="ucrindex.criteriosEnLinea"%>

<%
    request.setCharacterEncoding("UTF-8");

    HttpSession misession = request.getSession(true);
    misession.setMaxInactiveInterval(3600);
    
    criteriosEnLinea formularioEnLinea = new criteriosEnLinea();
    formularioEnLinea.setInteroperabilidad(request.getParameter("URL31"));
    formularioEnLinea.setFormatosEdicion(request.getParameter("checkCriterio32") != null);
    formularioEnLinea.setValorAgregado(request.getParameter("URL33"));
    formularioEnLinea.setInteractividad(request.getParameter("URL34"));
    formularioEnLinea.setBuscadores(request.getParameter("URL35"));
    formularioEnLinea.setIdentificadoresDeRecurso(request.getParameter("checkCriterio36") != null);
    formularioEnLinea.setEstadisticas(request.getParameter("URL37"));
    formularioEnLinea.setPoliticaPreservacion(request.getParameter("URL38"));

    formularioEnLinea.setObservacion31(request.getParameter("observacion31"));
    formularioEnLinea.setObservacion32(request.getParameter("observacion32"));
    formularioEnLinea.setObservacion33(request.getParameter("observacion33"));
    formularioEnLinea.setObservacion34(request.getParameter("observacion34"));
    formularioEnLinea.setObservacion35(request.getParameter("observacion35"));
    formularioEnLinea.setObservacion36(request.getParameter("observacion36"));
    formularioEnLinea.setObservacion37(request.getParameter("observacion37"));
    formularioEnLinea.setObservacion38(request.getParameter("observacion38"));

    misession.setAttribute("formularioEnLinea", formularioEnLinea);

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
        <h2 class="sinEspacios">Criterios UCRÍndex</h2>
        <h3>Total de criterios: 11 </h3>
        <form name="presentacion" action="envioUCRIndex.jsp" method="POST">
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
                        <td><strong>Mención de los meses de publicación</strong><br><br>La revista debe 
                            mencionar en la tabla de contenidos los meses que comprende el fascículo</td>
                        <td><input type="text" name="UCR1" placeholder='Ingrese el URL donde se encuentra' size="80" pattern="(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"></textarea></td>
                        <td><textarea name="observacionUCR1" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Cantidad de artículos publicados</strong><br><br>La revista debe publicar 
                            al menos 15 artículos al año, que serán contabilizados para el año inmediato anterior al periodo de evaluación. No se tomará en cuenta las notas técnicas, reseñas, estudios de caso, ensayos, obituarios, notas y cualquier otra tipología documental diferente al artículo</td>
                        <td><label for="articulosPublicados">Cantidad de artículos:</label>
                            <input type="number" id="articulosPublicados" name="articulosPublicados" min="0" max="99" value="0"></td>
                        <td><textarea name="observacionUCR2" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Cuerpo editorial internacional</strong><br><br>De la totalidad de 
                            miembros del Cuerpo Editorial un 66,7% deben tener afiliación institucional 
                            diferente al país de origen de la publicación. Para aquellos miembros que no 
                            cuenten con afiliación completa, que incluya nombre completo de la institución y 
                            país, se tomarán como nacionales.</td>
                        <td>
                            <label for="miembrosNacionales">Cantidad de miembros nacionales:</label>
                            <input type="number" id="miembrosNacionales" name="miembrosNacionales" min="0" max="99" value="0">
                            <br><br>
                            <label for="miembrosInternacionales">Cantidad de miembros internacionales:</label>
                            <input type="number" id="miembrosInternacionales" name="miembrosInternacionales" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionUCR3" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Evaluadores externos</strong><br><br>El 80% de los artículos publicados 
                            en el fascículo en evaluación, deben tener evaluadores externos a la institución editora. 
                            Si un artículo incluye más de un evaluador, se decidirá si el artículo es externo 
                            por mayoría simple, si no hay mayoría será considerado como interno.</td>
                        <td>
                            <label for="evaluadoresInternos">Cantidad de artículos con evaluadores internos:</label>
                            <input type="number" id="evaluadoresInternos" name="evaluadoresInternos" min="0" max="99" value="0">
                            <br><br>
                            <label for="evaluadoresExternos">Cantidad de artículos evaluadores externos</label>
                            <input type="number" id="evaluadoresExternos" name="evaluadoresExternos" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionUCR4" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Diversidad de idioma</strong><br><br>Toda la información incluida en 
                            la página de inicio de la revista debe estar al menos en dos idiomas. 
                            Asimismo, el título, resumen y palabras clave de todos los documentos 
                            estarán al menos en dos idiomas, y uno de ellos debe ser inglés, 
                            tanto en sus textos completos como en sus metadatos.</td>
                        <td><input type="checkbox" id="UCR4" name="UCR4" value="ON" />
                        <label for="UCR4">Cumple el criterio</label><br></td>
                        <td><textarea name="observacionUCR5" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Autores internacionales</strong><br><br>Un 50% de los documentos publicados deben 
                            proceder de autores extranjeros.  Artículos en coautoría entre 
                            extranjeros y nacionales son tomados en cuenta como artículos 
                            internacionales. Artículos con coautoría únicamente nacional no cumplen el criterio. 
                            Este criterio aplica a todos los tipos de documentos publicados por la revista, 
                            y aplica para el año anterior inmediato.</td>
                        <td>
                            <label for="articulosNacionales">Cantidad de documentos con autores nacionales</label><br>
                            <input type="number" id="articulosNacionales" name="articulosNacionales" min="0" max="99" value="0">
                            <br><br>
                            <label for="articulosInternacionales">Cantidad de documentos con autores internacionales</label><br>
                            <input type="number" id="articulosInternacionales" name="articulosInternacionales" min="0" max="99" value="0">
                        </td>
                        <td><textarea name="observacionUCR6" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Índices selectivos rigurosos</strong><br><br>Sistemas de información en que 
                            se incluye la revista, que aplican criterios de selección claros, y 
                            son aprobados por un comité científico. 
                            <br><a href="https://ucrindex.ucr.ac.cr/?page_id=992#accordion-1-t1">Ver lista oficial.</a></td>
                        <td>
                            <label for="indicesRigurosos">Cantidad de índices rigurosos</label>
                            <input type="number" id="indicesRigurosos" name="indicesRigurosos" min="0" max="99" value="0">
                            <br><br><em>Califica positivamente si tiene 2 o más.</em>
                        </td>
                        <td><textarea name="observacionUCR7" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Índices selectivos medianamente rigurosos</strong><br><br>Sistemas de información 
                            en que se incluye la revista, y que aplican criterios de selección claros, 
                            y son aprobados por un comité interno. 
                            <br><a href="https://ucrindex.ucr.ac.cr/?page_id=992#accordion-1-t2">Ver lista oficial.</a></td>
                        <td>
                            <label for="indicesMedianos">Cantidad de índices medianamente rigurosos</label>
                            <input type="number" id="indicesMedianos" name="indicesMedianos" min="0" max="99" value="0">
                            <br><br><em>Califica positivamente si tiene 3 o más.</em>
                        </td>
                        <td><textarea name="observacionUCR8" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Índices selectivos poco rigurosos</strong><br><br>Sistemas de información 
                            en que se incluye la revista, que únicamente aplican criterios de selección, 
                            sin comité de revisión. 
                            <br><a href="https://ucrindex.ucr.ac.cr/?page_id=992#accordion-1-t3">Ver lista oficial.</a></td>
                        <td>
                            <label for="indicesPoco">Cantidad de índices poco rigurosos</label>
                            <input type="number" id="indicesPoco" name="indicesPoco" min="0" max="99" value="0">
                            <br><br><em>Califica positivamente si tiene 4 o más.</em>
                        </td>
                        <td><textarea name="observacionUCR9" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Índices no selectivos</strong><br><br>La revista está incluida en índices, 
                            directorios y bases de datos que no realizan ningún proceso formal de
                            selección para las revistas de su colección. 
                            <br><a href="https://ucrindex.ucr.ac.cr/?page_id=992#accordion-1-t4">Ver lista oficial.</a></td>
                        <td>
                            <label for="indicesNo">Cantidad de índices no selectivos</label>
                            <input type="number" id="indicesNo" name="indicesNo" min="0" max="99" value="0">
                            <br><br><em>Califica positivamente si tiene 3 o más.</em>
                        </td>
                        <td><textarea name="observacionUCR10" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Guía de evaluación para el arbitraje</strong><br><br>La revista debe tener 
                            una guía o formulario de evaluación para los evaluadores de los artículos. 
                            Esta guía puede estar en su página oficial, o de ser privada; en este caso, 
                            debe ser enviada al equipo UCRÍndex antes del 7 de agosto del 2020.<br> 
                            <em>La Vicerrectoría conservará la información como privada y 
                                no será divulgada ni compartida.</em></td>
                        <td><input type="checkbox" id="UCR10" name="UCR10" value="ON" />
                        <label for="UCR10">Cumple el criterio</label><br></td>
                        <td><textarea name="observacionUCR11" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                    <tr>
                        <td><strong>Lista de evaluadores de la revista</strong><br><br>La revista debe suministrar 
                            la lista de evaluadores de cada fascículo. Dicha lista debe estar disponible al momento de la 
                            publicación, ya sea enviada al equipo UCR índex o ser incluída en la página oficial. 
                            La lista deberá seguir la siguiente estructura:<br>
                            -Datos del número: Título de la Revista, Volumen, número, año.<br>
                            -Título de los artículos;<br>
                            -Nombre de las personas revisoras de cada uno de los artículos;<br>
                            -Afiliación completa (nombre de la institución y país) de los revisores.
                        </td>
                        <td><input type="checkbox" id="UCR11" name="UCR11" value="ON" />
                        <label for="UCR11">Cumple el criterio</label><br></td>
                        <td><textarea name="observacionUCR12" rows="3" cols="30" maxlength="500"></textarea></td>
                    </tr>
                </tbody>
            </table>
            <br>       
            <div id="botonSiguiente"><input type="submit" value="Enviar Formulario UCRÍndex" name="enviarUCRIndex" onclick="javascript:return checkValidation()"/></div>      
        </form>
    </div>
    <footer>
        <p>Formulario para Evaluación UCRíndex</p>
    </footer>
    
    <script type="text/javascript">
        function checkValidation() {
            if (document.getElementById('miembrosNacionales').value === "") {
                alert("Por favor indique la cantidad de miembros editoriales nacionales (mínimo 0)");
                return false;
            }
            if (document.getElementById('miembrosInternacionales').value === "") {
                alert("Por favor indique la cantidad de miembros editoriales internacionales (mínimo 0)");
                return false;
            }
            if (document.getElementById('evaluadoresInternos').value === "") {
                alert("Por favor indique la cantidad de documentos con evaluadores internos (mínimo 0)");
                return false;
            }            
            if (document.getElementById('evaluadoresExternos').value === "") {
                alert("Por favor indique la cantidad de documentos con evaluadores externos (mínimo 0)");
                return false;
            }
            if (document.getElementById('articulosNacionales').value === "") {
                alert("Por favor indique la cantidad de documentos con autores nacionales (mínimo 0)");
                return false;
            }
            if (document.getElementById('articulosInternacionales').value === "") {
                alert("Por favor indique la cantidad de documentos con autores internacionales (mínimo 0)");
                return false;
            }
            if (document.getElementById('indicesRigurosos').value === "") {
                alert("Por favor indique la cantidad de índices selectivos rigurosos (mínimo 0)");
                return false;
            }            
            if (document.getElementById('indicesMedianos').value === "") {
                alert("Por favor indique la cantidad de índices selectivos medianamente rigurosos (mínimo 0)");
                return false;
            }
            if (document.getElementById('indicesPoco').value === "") {
                alert("Por favor indique la cantidad de índices selectivos poco rigurosos (mínimo 0)");
                return false;
            }            
            if (document.getElementById('indicesNo').value === "") {
                alert("Por favor indique la cantidad de índices no selectivos (mínimo 0)");
                return false;
            }
        }
    </script> 
    
</html>