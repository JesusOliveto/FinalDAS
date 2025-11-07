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

@Repository
public class ClicksRepository {

    @Autowired
    private JdbcTemplate jdbcTpl;

    @Autowired
    private ObjectMapper objectMapper;

    public ClickResponse registrarClick(ClickRequest req) {
        final String sql = "EXEC dbo.usp_registrar_click_contenido ?,?,?,?,?,?,?,?,?";

        List<String> rows = jdbcTpl.query(sql, ps -> {
            ps.setInt(1, req.getNroRestaurante());
            ps.setInt(2, req.getNroContenido());

            if (req.getNroCliente() == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, req.getNroCliente());

            if (req.getApellido() == null) ps.setNull(4, Types.VARCHAR);
            else ps.setString(4, req.getApellido());

            if (req.getNombre() == null) ps.setNull(5, Types.VARCHAR);
            else ps.setString(5, req.getNombre());

            if (req.getCorreo() == null) ps.setNull(6, Types.VARCHAR);
            else ps.setString(6, req.getCorreo());

            if (req.getTelefonos() == null) ps.setNull(7, Types.VARCHAR);
            else ps.setString(7, req.getTelefonos());

            if (req.getCostoClick() == null) ps.setNull(8, Types.DECIMAL);
            else ps.setBigDecimal(8, java.math.BigDecimal.valueOf(req.getCostoClick()));

            if (req.getFechaRegistro() == null) ps.setNull(9, Types.TIMESTAMP);
            else ps.setTimestamp(9, java.sql.Timestamp.valueOf(req.getFechaRegistro()));
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
