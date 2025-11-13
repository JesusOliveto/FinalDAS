package ar.edu.ubp.das.bodegon.exceptions;

import org.springframework.dao.DataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Manejador global de excepciones de la API.
 *
 * Unifica la forma de responder errores comunes (acceso a datos, estado ilegal, genéricos)
 * devolviendo estructuras simples JSON para el cliente.
 */
@ControllerAdvice
public class ApiExceptionHandler {

    /**
     * Maneja errores provenientes de la capa de acceso a datos (JdbcTemplate, etc.).
     * @param ex excepción de Spring DataAccessException
     * @return 400 con detalle simplificado del error subyacente
     */
    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<?> handleSql(DataAccessException ex) {
        return ResponseEntity.badRequest().body(Map.of(
                "error", "Error de acceso a datos",
                "detail", ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage()
        ));
    }

    /**
     * Maneja estados ilegales que la aplicación arroja deliberadamente cuando la lógica no se cumple.
     * @param ex excepción IllegalStateException
     * @return 400 con mensaje de negocio
     */
    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<?> handleIllegalState(IllegalStateException ex) {
        return ResponseEntity.badRequest().body(Map.of("error", ex.getMessage()));
    }

    /**
     * Manejo de fallback para cualquier excepción no contemplada.
     * @param ex excepción genérica
     * @return 500 con mensaje estándar
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGeneric(Exception ex) {
        return ResponseEntity.internalServerError().body(Map.of("error", "Error interno"));
    }
}
