package ar.edu.ubp.das.bodegon;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Clase principal de arranque de la aplicación Spring Boot Bodegon.
 * Contiene el método main que inicializa el contexto y levanta el servidor embebido.
 */
@SpringBootApplication
public class BodegonApplication {

    /**
     * Punto de entrada estándar de la JVM.
     * @param args argumentos de línea de comando (no utilizados).
     */
    public static void main(String[] args) {
        SpringApplication.run(BodegonApplication.class, args);
    }

}
