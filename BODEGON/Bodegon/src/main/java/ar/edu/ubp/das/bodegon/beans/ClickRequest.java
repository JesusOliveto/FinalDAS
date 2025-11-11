package ar.edu.ubp.das.bodegon.beans;

import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

public class ClickRequest {
    // Identificador público de contenido (requerido por el nuevo SP)
    @NotBlank
    @Size(max = 40)
    private String codContenidoRestaurante;

    // ---- Todos los de abajo son opcionales (click anónimo admitido) ----
    @Min(1)
    private Integer nroCliente;

    private String apellido;
    private String nombre;

    @Email
    private String correo;

    private String telefonos;

    private Double costoClick;
    private LocalDateTime fechaRegistro;

    // Getters / Setters
    public String getCodContenidoRestaurante() { return codContenidoRestaurante; }
    public void setCodContenidoRestaurante(String codContenidoRestaurante) { this.codContenidoRestaurante = codContenidoRestaurante; }

    public Integer getNroCliente() { return nroCliente; }
    public void setNroCliente(Integer nroCliente) { this.nroCliente = nroCliente; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getTelefonos() { return telefonos; }
    public void setTelefonos(String telefonos) { this.telefonos = telefonos; }

    public Double getCostoClick() { return costoClick; }
    public void setCostoClick(Double costoClick) { this.costoClick = costoClick; }

    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}
