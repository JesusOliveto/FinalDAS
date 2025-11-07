package ar.edu.ubp.das.bodegon.exceptions;

import org.springframework.dao.DataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<?> handleSql(DataAccessException ex) {
        return ResponseEntity.badRequest().body(Map.of(
                "error", "Error de acceso a datos",
                "detail", ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage()
        ));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<?> handleIllegalState(IllegalStateException ex) {
        return ResponseEntity.badRequest().body(Map.of("error", ex.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGeneric(Exception ex) {
        return ResponseEntity.internalServerError().body(Map.of("error", "Error interno"));
    }
}
