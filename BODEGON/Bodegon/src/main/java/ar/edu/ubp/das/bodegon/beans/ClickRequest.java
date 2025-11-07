package ar.edu.ubp.das.bodegon.beans;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

public class ClickRequest {
    @NotNull @Min(1)
    private Integer nroRestaurante;
    @NotNull @Min(1)
    private Integer nroContenido;
    @NotNull @Min(1)
    private Integer nroCliente;

    // opcionales en el SP
    private Double costoClick; // DECIMAL(12,2) -> usar Double/BigDecimal
    private LocalDateTime fechaRegistro; // si viene null, el SP usa SYSDATETIME()

    // getters & setters
    public Integer getNroRestaurante() { return nroRestaurante; }
    public void setNroRestaurante(Integer nroRestaurante) { this.nroRestaurante = nroRestaurante; }
    public Integer getNroContenido() { return nroContenido; }
    public void setNroContenido(Integer nroContenido) { this.nroContenido = nroContenido; }
    public Integer getNroCliente() { return nroCliente; }
    public void setNroCliente(Integer nroCliente) { this.nroCliente = nroCliente; }
    public Double getCostoClick() { return costoClick; }
    public void setCostoClick(Double costoClick) { this.costoClick = costoClick; }
    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDateTime fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}
