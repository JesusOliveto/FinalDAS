package ar.edu.ubp.das.bodegon.beans;

import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

public class ClickRequest {
    @NotNull @Min(1)
    private Integer nroRestaurante;

    @NotNull @Min(1)
    private Integer nroContenido;

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
    public Integer getNroRestaurante() { return nroRestaurante; }
    public void setNroRestaurante(Integer nroRestaurante) { this.nroRestaurante = nroRestaurante; }

    public Integer getNroContenido() { return nroContenido; }
    public void setNroContenido(Integer nroContenido) { this.nroContenido = nroContenido; }

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
