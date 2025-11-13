package ar.edu.ubp.das.bodegon.beans;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * DTO de salida para la respuesta del procedimiento dbo.usp_registrar_click_contenido.\n *\n * La estructura esperada es un objeto JSON con dos propiedades:\n *  - click: datos técnicos del clic registrado (restaurante, contenido, número de clic, fecha, costo, código público).\n *  - cliente: datos del cliente asociado si se pudo resolver o crear; puede venir null para clic anónimo.\n */
public class ClickResponse {

    @JsonProperty("click")
    private ClickDTO click;

    @JsonProperty("cliente")
    private ClienteDTO cliente;

    /** @return datos del clic registrado. */
    public ClickDTO getClick() { return click; }
    /** @param click datos del clic registrado. */
    public void setClick(ClickDTO click) { this.click = click; }

    /** @return datos del cliente resuelto o null si anónimo. */
    public ClienteDTO getCliente() { return cliente; }
    /** @param cliente datos del cliente resuelto. */
    public void setCliente(ClienteDTO cliente) { this.cliente = cliente; }

    // ==== Sub-objetos ====

    /**
     * Sub-DTO con los atributos técnicos del clic generado por la BD.\n     * Incluye los identificadores internos y el código público del contenido.\n     */
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

        @JsonProperty("cod_contenido_restaurante")
        private String codContenidoRestaurante;

        /** @return número interno de restaurante. */
        public Integer getNroRestaurante() { return nroRestaurante; }
        /** @param nroRestaurante número interno de restaurante. */
        public void setNroRestaurante(Integer nroRestaurante) { this.nroRestaurante = nroRestaurante; }
        /** @return número interno del contenido. */
        public Integer getNroContenido() { return nroContenido; }
        /** @param nroContenido número interno del contenido. */
        public void setNroContenido(Integer nroContenido) { this.nroContenido = nroContenido; }
        /** @return número incremental del clic. */
        public Integer getNroClick() { return nroClick; }
        /** @param nroClick número incremental de clic para ese contenido. */
        public void setNroClick(Integer nroClick) { this.nroClick = nroClick; }
        /** @return fecha/hora de registro del clic. */
        public String getFechaHoraRegistro() { return fechaHoraRegistro; }
        /** @param fechaHoraRegistro fecha/hora de registro. */
        public void setFechaHoraRegistro(String fechaHoraRegistro) { this.fechaHoraRegistro = fechaHoraRegistro; }
        /** @return costo aplicado al clic. */
        public Double getCostoClick() { return costoClick; }
        /** @param costoClick costo aplicado. */
        public void setCostoClick(Double costoClick) { this.costoClick = costoClick; }
        /** @return código público del contenido restaurante. */
        public String getCodContenidoRestaurante() { return codContenidoRestaurante; }
        /** @param codContenidoRestaurante código público de contenido. */
        public void setCodContenidoRestaurante(String codContenidoRestaurante) { this.codContenidoRestaurante = codContenidoRestaurante; }
    }

    /**
     * Sub-DTO con los datos básicos del cliente asociado al clic.\n     * Puede retornar todos los campos null si el clic fue anónimo.\n     */
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

        /** @return número interno de cliente. */
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
        /** @return correo del cliente. */
        public String getCorreo() { return correo; }
        /** @param correo correo del cliente. */
        public void setCorreo(String correo) { this.correo = correo; }
        /** @return teléfonos del cliente. */
        public String getTelefonos() { return telefonos; }
        /** @param telefonos teléfonos del cliente. */
        public void setTelefonos(String telefonos) { this.telefonos = telefonos; }
    }
}
