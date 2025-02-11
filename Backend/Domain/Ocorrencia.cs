using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Domain
{
    public class Ocorrencia
    {
        public Guid Id { get; set; }
        public string FotoVideo { get; set; }
        public DateTime DataHora { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string Descricao { get; set; }
        public string Classificar { get; set; } //1 Urgente, 2 Não Urgente

        public Guid UtilizadorId { get; set; }
        [ForeignKey(nameof(UtilizadorId))]
        public Utilizador Utilizador { get; set; }

//        [NotMapped]
        //public List<Utilizador> UserParilhados { get; set; } = new List<Utilizador>();
    }
}
