package ar.edu.ubp.das.bodegon;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Inicializador para despliegue tradicional WAR en un contenedor externo (Tomcat).
 * Permite que el servidor aplique la configuración de la aplicación Spring Boot.
 */
public class ServletInitializer extends SpringBootServletInitializer {

    /**
     * Configura la fuente principal de la aplicación al empaquetar como WAR.
     * @param application builder provisto por el contenedor
     * @return builder configurado
     */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(BodegonApplication.class);
    }

}
