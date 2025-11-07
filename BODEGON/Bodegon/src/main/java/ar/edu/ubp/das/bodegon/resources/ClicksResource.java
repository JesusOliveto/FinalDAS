package ar.edu.ubp.das.bodegon.resources;

import ar.edu.ubp.das.bodegon.beans.ClickRequest;
import ar.edu.ubp.das.bodegon.beans.ClickResponse;
import ar.edu.ubp.das.bodegon.repositories.ClicksRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/clicks")
public class ClicksResource {

    @Autowired
    private ClicksRepository repository;

    @PostMapping
    public ResponseEntity<ClickResponse> registrar(@Valid @RequestBody ClickRequest request) {
        ClickResponse resp = repository.registrarClick(request);
        return ResponseEntity.status(201).body(resp);
    }
}
