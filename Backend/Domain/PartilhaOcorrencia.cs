using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Domain
{
    public class PartilhaOcorrencia
    {
        [Key]
        public Guid Id { get; set; }

        public Guid OcorrenciaId { get; set; }
        [ForeignKey(nameof(OcorrenciaId))]
        public Ocorrencia Ocorrencia { get; set; }
        public Guid UtilizadorId { get; set; }
        [ForeignKey(nameof(UtilizadorId))]
        public Utilizador Utilizador { get; set; }
    }
}
