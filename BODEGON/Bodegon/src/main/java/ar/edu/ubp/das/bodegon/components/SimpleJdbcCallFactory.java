package ar.edu.ubp.das.bodegon.components;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Factoría utilitaria para ejecutar procedimientos almacenados con SimpleJdbcCall.
 *
 * Centraliza la creación del objeto y expone métodos simplificados para obtener el mapa de salida
 * incluyendo result sets especiales ("#result-set-n").
 */
@Component
public class SimpleJdbcCallFactory {

    @Autowired
    private JdbcTemplate jdbcTpl;

    /**
     * Ejecuta un SP devolviendo parámetros OUT y posibles result sets.
     * @param procedureName nombre del procedimiento
     * @param schemaName esquema (schema) donde reside
     * @param params parámetros de entrada
     * @return mapa con OUT params y result sets
     */
    public Map<String, Object> executeWithOutputs(String procedureName, String schemaName, SqlParameterSource params) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTpl)
                .withProcedureName(procedureName)
                .withSchemaName(schemaName);
        return jdbcCall.execute(params);
    }

    /**
     * Versión sin parámetros de entrada.
     * @param procedureName nombre del procedimiento
     * @param schemaName esquema
     * @return mapa con resultados
     */
    public Map<String, Object> executeWithOutputs(String procedureName, String schemaName) {
        return executeWithOutputs(procedureName, schemaName, new MapSqlParameterSource());
    }

    /**
     * Ejecuta el SP y devuelve todo el mapa OUT, incluyendo juegos de resultados bajo claves tipo "#result-set-1".
     * Útil cuando el SP hace un SELECT final (p.ej. SELECT ... FOR JSON PATH).
     * @param procedureName nombre del procedimiento
     * @param schemaName esquema
     * @param params parámetros de entrada
     * @return mapa de salida completo
     */
    public Map<String, Object> executeReturningEverything(String procedureName, String schemaName, SqlParameterSource params) {
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTpl)
                .withProcedureName(procedureName)
                .withSchemaName(schemaName);
        return jdbcCall.execute(params);
    }
}
