package ar.edu.ubp.das.bodegon.beans;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ClickResponse {

    @JsonProperty("click")
    private ClickDTO click;

    @JsonProperty("cliente")
    private ClienteDTO cliente;

    public ClickDTO getClick() { return click; }
    public void setClick(ClickDTO click) { this.click = click; }

    public ClienteDTO getCliente() { return cliente; }
    public void setCliente(ClienteDTO cliente) { this.cliente = cliente; }

    // ==== Sub-objetos ====

    public static class ClickDTO {
        @JsonProperty("nro_restaurante")
        private Integer nroRestaurante;

        @JsonProperty("nro_contenido")
        private Integer nroContenido;

        @JsonProperty("nro_click")
        private Integer nroClick;

        @JsonProperty("fecha_hora_registro")
        private String fechaHoraRegistro;

        @JsonProperty("costo_click")
        private Double costoClick;

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

    public static class ClienteDTO {
        @JsonProperty("nro_cliente")
        private Integer nroCliente;

        @JsonProperty("apellido")
        private String apellido;

        @JsonProperty("nombre")
        private String nombre;

        @JsonProperty("correo")
        private String correo;

        @JsonProperty("telefonos")
        private String telefonos;

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
    }
}
