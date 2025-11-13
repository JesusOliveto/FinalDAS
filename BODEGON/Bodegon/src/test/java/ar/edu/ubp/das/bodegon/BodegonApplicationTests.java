package ar.edu.ubp.das.bodegon;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Test mínimo de smoke que verifica que el contexto Spring Boot se levanta correctamente.
 * Se puede extender añadiendo pruebas a componentes específicos posteriores.
 */
@SpringBootTest
class BodegonApplicationTests {

    /** Verifica que el contexto se inicializa sin excepciones. */
    @Test
    void contextLoads() {
    }

}
