package ar.edu.ubp.das.bodegon.resources;

import ar.edu.ubp.das.bodegon.beans.ClickRequest;
import ar.edu.ubp.das.bodegon.beans.ClickResponse;
import ar.edu.ubp.das.bodegon.repositories.ClicksRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Recurso REST para registrar clics de contenidos publicitarios.
 *
 * Endpoint principal: POST /clicks
 * Body: JSON mapeado a {@link ClickRequest}
 * Respuesta: 201 + JSON del clic registrado ({@link ClickResponse}).
 *
 * Se apoya en {@link ClicksRepository} para la interacción con el procedimiento almacenado.
 */
@RestController
@RequestMapping("/clicks")
public class ClicksResource {

    @Autowired
    private ClicksRepository repository;

    /**
     * Registra un clic sobre un contenido identificado por su código público.
     * @param request payload validado con Bean Validation
     * @return respuesta del SP parseada en objeto
     */
    @PostMapping
    public ResponseEntity<ClickResponse> registrar(@Valid @RequestBody ClickRequest request) {
        ClickResponse resp = repository.registrarClick(request);
        return ResponseEntity.status(201).body(resp);
    }
}
