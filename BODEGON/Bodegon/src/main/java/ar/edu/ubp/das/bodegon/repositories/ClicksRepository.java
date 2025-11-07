package ar.edu.ubp.das.bodegon.repositories;

import ar.edu.ubp.das.bodegon.beans.ClickRequest;
import ar.edu.ubp.das.bodegon.beans.ClickResponse;
import ar.edu.ubp.das.bodegon.components.SimpleJdbcCallFactory;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import java.sql.Types;
import java.util.List;
import java.util.Map;

@Repository
public class ClicksRepository {

    private static final String SCHEMA = "dbo";
    private static final String PROC   = "usp_registrar_click_contenido";

    @Autowired
    private SimpleJdbcCallFactory jdbcCallFactory;

    @Autowired
    private ObjectMapper objectMapper;

    public ClickResponse registrarClick(ClickRequest req) {
        SqlParameterSource params = new MapSqlParameterSource()
                .addValue("nro_restaurante", req.getNroRestaurante(), Types.INTEGER)
                .addValue("nro_contenido",   req.getNroContenido(),   Types.INTEGER)
                .addValue("nro_cliente",     req.getNroCliente(),     Types.INTEGER)
                .addValue("costo_click",     req.getCostoClick(),     Types.DECIMAL)
                .addValue("fecha_registro",  req.getFechaRegistro()); // JDBC mapea LocalDateTime

        Map<String, Object> out = jdbcCallFactory
                .executeReturningEverything(PROC, SCHEMA, params);

        // El SELECT ... FOR JSON PATH devuelve #result-set-1 -> List<Map<String,Object>>
        List<Map<String, Object>> rs = (List<Map<String, Object>>) out.get("#result-set-1");
        if (rs == null || rs.isEmpty()) {
            throw new IllegalStateException("El procedimiento no devolvió datos.");
        }
        Map<String, Object> firstRow = rs.get(0);

        // Tomamos el primer valor de la fila (la columna única con el JSON)
        Object firstValue = firstRow.values().iterator().next();
        if (firstValue == null) {
            throw new IllegalStateException("Respuesta vacía del procedimiento.");
        }

        try {
            String json = firstValue.toString();
            return objectMapper.readValue(json, ClickResponse.class);
        } catch (Exception ex) {
            throw new RuntimeException("No se pudo parsear el JSON devuelto por el SP.", ex);
        }
    }
}
