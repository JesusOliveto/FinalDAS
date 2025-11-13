package ar.edu.ubp.das.bodegon.repositories;

import ar.edu.ubp.das.bodegon.beans.ClickRequest;
import ar.edu.ubp.das.bodegon.beans.ClickResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Types;
import java.util.List;

/**
 * Repositorio encargado de invocar el procedimiento almacenado dbo.usp_registrar_click_contenido.\n *\n * Encapsula la construcción del PreparedStatement para pasar todos los parámetros opcionales\n * y hace el parseo del JSON devuelto (incluyendo normalización si el SP retorna strings con JSON interno).\n *\n * Manejo de errores: si el SP no devuelve una fila JSON se lanza IllegalStateException.\n */
@Repository
public class ClicksRepository {

    @Autowired
    private JdbcTemplate jdbcTpl;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * Invoca el SP de registro de clic pasando los parámetros presentes en el request.\n     * @param req datos de entrada del clic\n     * @return estructura parseada del JSON retornado por SQL Server\n     */
    public ClickResponse registrarClick(ClickRequest req) {
        final String sql = "EXEC dbo.usp_registrar_click_contenido ?,?,?,?,?,?,?,?";

        System.out.printf("[registrarClick] cod=%s nroCliente=%s apellido=%s nombre=%s correo=%s telefonos=%s costo=%s fecha=%s%n",
                req.getCodContenidoRestaurante(), req.getNroCliente(), req.getApellido(), req.getNombre(),
                req.getCorreo(), req.getTelefonos(), req.getCostoClick(), req.getFechaRegistro());

        List<String> rows = jdbcTpl.query(sql, ps -> {
            // 1) cod_contenido_restaurante (VARCHAR(40))
            if (req.getCodContenidoRestaurante() == null) ps.setNull(1, Types.VARCHAR);
            else ps.setString(1, req.getCodContenidoRestaurante());

            // 2) nro_cliente (INT)
            if (req.getNroCliente() == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, req.getNroCliente());

            // 3) apellido (VARCHAR(120))
            if (req.getApellido() == null) ps.setNull(3, Types.VARCHAR);
            else ps.setString(3, req.getApellido());

            // 4) nombre (VARCHAR(120))
            if (req.getNombre() == null) ps.setNull(4, Types.VARCHAR);
            else ps.setString(4, req.getNombre());

            // 5) correo (VARCHAR(200))
            if (req.getCorreo() == null) ps.setNull(5, Types.VARCHAR);
            else ps.setString(5, req.getCorreo());

            // 6) telefonos (VARCHAR(120))
            if (req.getTelefonos() == null) ps.setNull(6, Types.VARCHAR);
            else ps.setString(6, req.getTelefonos());

            // 7) costo_click (DECIMAL(12,2))
            if (req.getCostoClick() == null) ps.setNull(7, Types.DECIMAL);
            else ps.setBigDecimal(7, java.math.BigDecimal.valueOf(req.getCostoClick()));

            // 8) fecha_registro (DATETIME2(0))
            if (req.getFechaRegistro() == null) ps.setNull(8, Types.TIMESTAMP);
            else ps.setTimestamp(8, java.sql.Timestamp.valueOf(req.getFechaRegistro()));
        }, (rs, rn) -> rs.getString(1));

        if (rows == null || rows.isEmpty() || rows.get(0) == null) {
            throw new IllegalStateException("El procedimiento no devolvió JSON (fila vacía).");
        }

        String rawJson = rows.get(0);
        System.out.println("[SP JSON] " + rawJson);

        try {
            JsonNode root = objectMapper.readTree(rawJson);
            if (root.isObject()) {
                ObjectNode obj = (ObjectNode) root;
                // Si “click/cliente” vinieran como strings, normalizá a objeto:
                if (obj.has("click") && obj.get("click").isTextual())
                    obj.set("click", objectMapper.readTree(obj.get("click").asText()));
                if (obj.has("cliente") && obj.get("cliente").isTextual())
                    obj.set("cliente", objectMapper.readTree(obj.get("cliente").asText()));

                return objectMapper.treeToValue(obj, ClickResponse.class);
            } else {
                throw new IllegalStateException("JSON raíz no es objeto.");
            }
        } catch (Exception ex) {
            String preview = rawJson.length() > 400 ? rawJson.substring(0, 400) + "..." : rawJson;
            throw new IllegalStateException("No se pudo parsear el JSON devuelto por el SP. Preview=" + preview, ex);
        }
    }
}
