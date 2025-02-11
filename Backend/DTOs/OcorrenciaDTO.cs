using System.ComponentModel.DataAnnotations.Schema;
using WebApi.Domain;

namespace WebApi.DTOs
{
    public class OcorrenciaDTO
    {
        public Guid Id { get; set; }
        public string? Latitude { get; set; }
        public string? Longitude { get; set; }
        public string? Descricao { get; set; }
        public string? Classificar { get; set; } //1 Urgente, 2 Não Urgente
        public Guid UtilizadorId { get; set; }
        public IFormFile? File { get; set; }
    }
}
