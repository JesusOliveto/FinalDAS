package ar.edu.ubp.das.bodegon.beans;

import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

/**
 * DTO de entrada para registrar un clic sobre un contenido publicitario del Bodegón.
 * Este objeto modela el payload JSON recibido por el endpoint POST /clicks.
 * La lógica delegada al procedimiento almacenado dbo.usp_registrar_click_contenido
 * admite registrar un clic anónimo (sin datos de cliente) o intentar asociarlo
 * a un cliente existente / crear uno nuevo mediante correo y datos mínimos.
 *
 * Reglas principales (validadas parcial vía Bean Validation y luego por el SP):
 * - codContenidoRestaurante: obligatorio, corresponde a cod_contenido_restaurante (único).
 * - nroCliente: opcional; si se envía y existe se usa.
 * - correo: opcional; si existe busca cliente; si no existe y hay nombre+apellido crea uno.
 * - costoClick: opcional; si se omite puede aplicarse el costo vigente del contenido en backend/BD.
 * - fechaRegistro: opcional; si es null el SP utiliza SYSDATETIME().
 */
public class ClickRequest {
    /** Identificador público único del contenido; mapea al parámetro @cod_contenido_restaurante del SP. */
    @NotBlank
    @Size(max = 40)
    private String codContenidoRestaurante;

    /** Número interno del cliente; si se provee y existe se toma directamente. */
    @Min(1)
    private Integer nroCliente;

    /** Apellido del cliente (solo necesario para alta por correo si aún no existe). */
    private String apellido;
    /** Nombre del cliente (solo necesario para alta por correo si aún no existe). */
    private String nombre;

    /** Correo electrónico; clave natural para localizar o crear cliente. */
    @Email
    private String correo;

    /** Teléfonos de contacto del cliente (libre). */
    private String telefonos;

    /** Costo del clic; si null el SP puede aplicar valor por defecto. */
    private Double costoClick;
    /** Fecha/hora deseada para registrar el clic; si null el SP usará SYSDATETIME(). */
    private LocalDateTime fechaRegistro;

    // Getters / Setters
    /** @return código público del contenido restaurante. */
    public String getCodContenidoRestaurante() { return codContenidoRestaurante; }
    /** @param codContenidoRestaurante código público único del contenido. */
    public void setCodContenidoRestaurante(String codContenidoRestaurante) { this.codContenidoRestaurante = codContenidoRestaurante; }

    /** @return número interno de cliente (opcional). */
    public Integer getNroCliente() { return nroCliente; }
    /** @param nroCliente número interno de cliente. */
    public void setNroCliente(Integer nroCliente) { this.nroCliente = nroCliente; }

    /** @return apellido del cliente. */
    public String getApellido() { return apellido; }
    /** @param apellido apellido del cliente. */
    public void setApellido(String apellido) { this.apellido = apellido; }

    /** @return nombre del cliente. */
    public String getNombre() { return nombre; }
    /** @param nombre nombre del cliente. */
    public void setNombre(String nombre) { this.nombre = nombre; }

    /** @return correo electrónico del cliente. */
    public String getCorreo() { return correo; }
    /** @param correo correo electrónico del cliente. */
    public void setCorreo(String correo) { this.correo = correo; }

    /** @return teléfonos del cliente. */
    public String getTelefonos() { return telefonos; }
    /** @param telefonos teléfonos del cliente. */
    public void setTelefonos(String telefonos) { this.telefonos = telefonos; }

    /** @return costo aplicado al clic. */
    public Double getCostoClick() { return costoClick; }
    /** @param costoClick costo a aplicar override. */
    public void setCostoClick(Double costoClick) { this.costoClick = costoClick; }

    /** @return fecha/hora registro solicitada. */
    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    /** @param fechaRegistro fecha/hora deseada para persistir. */
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}
