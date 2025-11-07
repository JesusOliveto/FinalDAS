package ar.edu.ubp.das.bodegon.beans;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ClickResponse {

    @JsonProperty("nro_restaurante")
    private Integer nroRestaurante;

    @JsonProperty("nro_contenido")
    private Integer nroContenido;

    @JsonProperty("nro_click")
    private Integer nroClick;

    @JsonProperty("fecha_hora_registro")
    private String fechaHoraRegistro; // podés mapear a LocalDateTime si querés

    @JsonProperty("costo_click")
    private Double costoClick;

    // getters & setters
    public Integer getNroRestaurante() { return nroRestaurante; }
    public void setNroRestaurante(Integer nroRestaurante) { this.nroRestaurante = nroRestaurante; }
    public Integer getNroContenido() { return nroContenido; }
    public void setNroContenido(Integer nroContenido) { this.nroContenido = nroContenido; }
    public Integer getNroClick() { return nroClick; }
    public void setNroClick(Integer nroClick) { this.nroClick = nroClick; }
    public String getFechaHoraRegistro() { return fechaHoraRegistro; }
    public void setFechaHoraRegistro(String fechaHoraRegistro) { this.fechaHoraRegistro = fechaHoraRegistro; }
    public Double getCostoClick() { return costoClick; }
    public void setCostoClick(Double costoClick) { this.costoClick = costoClick; }
}
